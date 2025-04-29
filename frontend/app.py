from flask import Flask, render_template, request,jsonify
import cx_Oracle
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

app = Flask(__name__)

# Oracle database connection string
DATABASE_URI = 'oracle+oracledb://system:asian123@vidhipc:1521/xe'

# Create an engine and session
engine = create_engine(DATABASE_URI, echo=True)
Session = sessionmaker(bind=engine)
session = Session()


# Fetch user details by ID
def get_user_details(user_id):
    result = session.execute(text("""
        SELECT u.user_id, u.name, u.email_id, u.role, u.contact_num
        FROM users u
        WHERE u.user_id = :id
    """), {'id': user_id}).fetchone()
    '''print("Retrieved user data:", result)'''
    return result


# Call PL/SQL stored procedure and capture DBMS_OUTPUT
def call_search_available_buggies_fare(user_id):
    dsn = cx_Oracle.makedsn("vidhipc", 1521, service_name="xe")
    conn = cx_Oracle.connect(user="system", password="asian123", dsn=dsn)
    cursor = conn.cursor()

    # Enable DBMS_OUTPUT
    cursor.callproc("dbms_output.enable")

    try:
        cursor.callproc("search_available_buggies_fare", [user_id])

        # Fetch DBMS_OUTPUT lines
        lines = []
        statusVar = cursor.var(cx_Oracle.NUMBER)
        lineVar = cursor.var(cx_Oracle.STRING)

        while True:
            cursor.callproc("dbms_output.get_line", (lineVar, statusVar))
            if statusVar.getvalue() != 0:
                break
            lines.append(lineVar.getvalue())

        return lines
    except cx_Oracle.DatabaseError as e:
        print("Oracle error:", e)
        return ["Error occurred while calling procedure."]
    finally:
        cursor.close()
        conn.close()


def book_buggy(user_id, buggy_id, pickup_point, drop_point, booking_status, booking_date):
    try:
        # Insert booking using stored procedure
        session.execute(text("""
            BEGIN
                book_buggy(
                    :user_id,
                    :buggy_id,
                    :pickup_point,
                    :drop_point,
                    :booking_status,
                    TO_DATE(:booking_date, 'YYYY-MM-DD')
                );
            END;
        """), {
            'user_id': user_id,
            'buggy_id': buggy_id,
            'pickup_point': pickup_point,
            'drop_point': drop_point,
            'booking_status': booking_status,
            'booking_date': booking_date
        })
        session.commit()

        # Fetch the latest booking for this user and buggy
        result = session.execute(text("""
            SELECT booking_id, buggy_id, user_id, driver_id, pickup_point, drop_point,
                   TO_CHAR(booking_time, 'DD-MON-YYYY HH24:MI:SS') AS booking_time,
                   invoice_id, TO_CHAR(invoice_date, 'DD-MON-YYYY') AS invoice_date, fare
            FROM bookings
            WHERE user_id = :user_id AND buggy_id = :buggy_id
            ORDER BY booking_time DESC FETCH FIRST 1 ROWS ONLY
        """), {
            'user_id': user_id,
            'buggy_id': buggy_id
        }).fetchone()

        if result:
            invoice = {
                'booking_id': result[0],
                'buggy_id': result[1],
                'user_id': result[2],
                'driver_id': result[3],
                'pickup_point': result[4],
                'drop_point': result[5],
                'booking_time': result[6],
                'invoice_id': result[7],
                'invoice_date': result[8],
                'fare': result[9]
            }
            return invoice
        else:
            return "Booking succeeded, but invoice not found."

    except Exception as e:
        session.rollback()
        return f"Error occurred: {str(e)}"

@app.route('/', methods=['GET', 'POST'])
def index():
    user_details = None
    buggy_fare_output = None
    booking_message = None
    invoice_details = None
    buggies = None

    if request.method == 'POST':
        user_id = request.form['user_id']
        user_details = get_user_details(user_id)

        if user_details:
            buggy_fare_output = call_search_available_buggies_fare(user_id)

            if 'book_buggy' in request.form:
                buggy_id = request.form['buggy_id']
                pickup_point = request.form['pickup_point']
                drop_point = request.form['drop_point']
                status = request.form['status']
                date = request.form['date']

                booking_result = book_buggy(user_id, buggy_id, pickup_point, drop_point, status, date)
                if isinstance(booking_result, dict):
                    booking_message = "Booking executed successfully."
                    invoice_details = booking_result
                else:
                    booking_message = booking_result
        else:
            booking_message = "No user found with the given ID"

    return render_template('index.html',
        user_details=user_details,
        available_buggies_routes=buggy_fare_output,
        booking_message=booking_message,
        invoice_details=invoice_details
    )
@app.route('/admin', methods=['GET', 'POST'])
def admin():
    role_check_result = None
    is_admin = False
    admin_output = None
    bookings = None
    maintainance = None
    buggies=None

    if request.method == 'POST':
        user_id = request.form['user_id']

        if user_id:
            result = session.execute(text("SELECT role FROM users WHERE user_id = :uid"), {"uid": user_id}).fetchone()

            if result and result[0].lower() == 'admin':
                role_check_result = f"User ID {user_id} has ADMIN privileges."
                is_admin = True
                admin_output = "Admin rights confirmed. You can now view bookings, maintenance, and add buggies."
            elif result:
                role_check_result = f"User ID {user_id} is NOT an admin (Role: {result[0]})."
                admin_output = "This user is not an admin."
            else:
                role_check_result = f"No user found with ID {user_id}."
                admin_output = "User not found."
        else:
            role_check_result = "No user ID provided."
            admin_output = "Please enter a valid user ID."

        action = request.form.get('action')

        if action == 'view_bookings':
            bookings = session.execute(text("""
                SELECT booking_id, buggy_id, user_id, driver_id, pickup_point, drop_point,
                       TO_CHAR(booking_time, 'DD-MON-YYYY HH24:MI:SS') AS booking_time,
                       invoice_id, TO_CHAR(invoice_date, 'DD-MON-YYYY') AS invoice_date, fare, status
                FROM bookings
                ORDER BY booking_id DESC
            """)).fetchall()
        elif action == 'view_maintenance':
            maintainance = session.execute(text("""
                SELECT maintainance_date, buggy_id, status 
               FROM maintainance 
               ORDER BY buggy_id ASC
                   """)).fetchall()
        
        elif action == 'add_buggy':
           buggies = session.execute(text("""
           SELECT buggy_id, model, capacity, status, location, driver_id
           FROM buggy ORDER BY buggy_id ASC
           """)).fetchall()
        

        

    return render_template('admin_index.html',
                           role_check_result=role_check_result,
                           is_admin=is_admin,
                           admin_output=admin_output,
                           bookings=bookings,
                           maintainance=maintainance,
                           buggies=buggies)


if __name__ == '__main__':
    app.run(debug=True)



