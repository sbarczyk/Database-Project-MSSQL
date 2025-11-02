import pyodbc
from faker import Faker
import random
import datetime

#################################################################
# KONFIGURACJA POŁĄCZENIA                                       #
#################################################################
connection_string = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=dbmanage.lab.ii.agh.edu.pl;"
    "DATABASE=u_sbarczyk;"
    "UID=u_sbarczyk;"
    "PWD=TMefpcGmGTrO;"
)

#################################################################
# PARAMETRY OGÓLNE I LICZBOWE                                   #
#################################################################

faker = Faker(["pl_PL"])
random.seed(42)

# Łącznie 200 użytkowników:
NUM_USERS = 200

# Rozkład ról:
NUM_TUTORS = 25
NUM_TRANSLATORS = 10
NUM_COORDINATORS = 15
NUM_STUDENTS = 150  # Suma = 200

NUM_LANGUAGES = 10
NUM_CURRENCIES = 5
NUM_ROOMS = 20
NUM_RODO = 150
NUM_ADDRESS = 200  # Każdy user ma 1 adres

# Produkty:
NUM_COURSES = 40
NUM_WEBINARS = 50
NUM_STUDIES = 30
NUM_STUDY_SESSIONS = 100

# Moduły:
NUM_COURSE_MODULES = 100  # W CourseModules moduleID nie jest IDENTITY
NUM_STUDY_MODULES = 80    # W studyModules moduleID jest IDENTITY

# Spotkania:
NUM_MEETINGS = 150
NUM_STATIONARY_MEETINGS = 30
NUM_ONLINE_SYNC_MEETINGS = 40
NUM_ONLINE_ASYNC_MEETINGS = 30

# Ile powiązań w moduleMeetings (jeśli PK jest (meetingID), nie wolno powtarzać meetingID):
NUM_MODULE_MEETINGS = 100  # Dostosowane do unikalności meetingID

# **Trzykrotnie zwiększone** wielokrotne wpisy:
NUM_MEETING_ATTENDANCE = 1500
NUM_WEBINAR_ATTENDANCE = 720
NUM_COURSE_MODULES_PASSED = 1200

NUM_WEBINAR_ACCESS = 80
NUM_COURSE_ACCESS = 100
NUM_STUDIES_PARTICIPANTS = 100
NUM_STUDY_MODULE_PARTICIPANTS = 100
NUM_INTERNSHIP = 20
NUM_INTERNSHIP_MEETING = 80
NUM_STUDENT_ACHIEVEMENTS = 60

# Koszyki i zamówienia:
NUM_CARTS = 100
NUM_CART_DETAILS = 150
NUM_ORDERS = 120
NUM_ORDER_DETAILS = 200
NUM_ORDER_PAYMENTS = 150

# Historia cen:
NUM_PRICE_HISTORY_PER_PRODUCT = 2
NUM_SUBSTITUTION = 25

#################################################################
# FUNKCJE POMOCNICZE                                             #
#################################################################
def random_date(start_year=2020, end_year=2025):
    start_date = datetime.date(start_year, 1, 1)
    end_date = datetime.date(end_year, 12, 31)
    delta = (end_date - start_date).days
    rand_days = random.randint(0, delta)
    return start_date + datetime.timedelta(days=rand_days)

def random_datetime(start_year=2022, end_year=2025):
    d = random_date(start_year, end_year)
    hour = random.randint(8, 20)
    minute = random.randint(0, 59)
    return datetime.datetime(d.year, d.month, d.day, hour, minute)

def insert_many(cursor, table_name, columns, values):
    placeholders = "(" + ",".join(["?"] * len(columns)) + ")"
    col_string = "(" + ",".join(columns) + ")"
    sql = f"INSERT INTO {table_name} {col_string} VALUES {placeholders}"
    cursor.executemany(sql, values)

#################################################################
# GŁÓWNA FUNKCJA                                                 #
#################################################################
def main():
    conn = pyodbc.connect(connection_string)
    cursor = conn.cursor()

    # ============================================================
    # 1. Tabele "pomocnicze": languages, currencies, rooms
    # ============================================================
    language_pool = [
        "Polski", "Angielski", "Niemiecki", "Francuski", "Hiszpański",
        "Włoski", "Rosyjski", "Ukraiński", "Chiński", "Japoński",
        "Portugalski", "Czeski", "Słowacki", "Litewski"
    ]
    random.shuffle(language_pool)
    lang_inserts = []
    for i in range(NUM_LANGUAGES):
        lang_id = i + 1
        name = language_pool[i % len(language_pool)]
        lang_inserts.append((lang_id, name))
    insert_many(cursor, "languages", ("id","name"), lang_inserts)

    # Waluty (realistyczne kursy względem PLN)
    real_currencies = [
        ("PLN", 1.0),
        ("EUR", 4.5),
        ("USD", 4.0),
        ("GBP", 5.2),
        ("CHF", 4.6)
    ]
    insert_many(cursor, "currencies", ("currencyName","currencyRate"), real_currencies)

    # ROOMS
    room_inserts = []
    for _ in range(NUM_ROOMS):
        rname = f"Sala {random.randint(1, 999)}"
        limit = random.randint(15, 120)
        room_inserts.append((rname, limit))
    insert_many(cursor, "Rooms", ("name","placeLimit"), room_inserts)

    cursor.execute("SELECT id FROM Rooms ORDER BY id")
    all_room_ids = [row.id for row in cursor.fetchall()]

    # ============================================================
    # 2. Users (200) i role
    # ============================================================
    users_inserts = []
    # Generujemy e-mail pasujący do imienia i nazwiska
    for i in range(NUM_USERS):
        fname = faker.first_name()
        lname = faker.last_name()
        # Stworzymy email = imie.nazwisko{i}@example.com
        email_local = f"{fname.lower()}.{lname.lower()}{i}"
        mail = email_local + "@example.com"
        pwd = faker.password(length=8)
        users_inserts.append((fname, lname, mail, pwd))

    insert_many(cursor, "users", ("firstName","lastName","email","password"), users_inserts)

    cursor.execute("SELECT userID FROM users ORDER BY userID")
    all_user_ids = [row.userID for row in cursor.fetchall()]

    # Rozdzielamy role w sposób deterministyczny:
    tutor_ids = all_user_ids[0:NUM_TUTORS]
    translator_ids = all_user_ids[NUM_TUTORS : NUM_TUTORS + NUM_TRANSLATORS]
    coordinator_ids = all_user_ids[NUM_TUTORS + NUM_TRANSLATORS : NUM_TUTORS + NUM_TRANSLATORS + NUM_COORDINATORS]
    student_ids = all_user_ids[NUM_TUTORS + NUM_TRANSLATORS + NUM_COORDINATORS : ]

    # TUTORS
    insert_many(cursor, "tutors", ("tutorID",), [(t,) for t in tutor_ids])

    # TRANSLATORS
    translator_inserts = []
    for t in translator_ids:
        lid = random.randint(1, NUM_LANGUAGES)
        translator_inserts.append((t, lid))
    insert_many(cursor, "translators", ("translatorID","languageID"), translator_inserts)

    # COORDINATORS
    insert_many(cursor, "coordinators", ("coordinatorID",), [(c,) for c in coordinator_ids])

    # STUDENTS
    insert_many(cursor, "students", ("studentID",), [(s,) for s in student_ids])

    # ============================================================
    # 3. address (każdy user ma 1 adres, w Polsce) + RODO
    # ============================================================
    address_inserts = []
    for uid in all_user_ids:
        country = "Polska"
        city = faker.city()
        street = f"{faker.street_name()} {random.randint(1,100)}"
        zipcode = f"{random.randint(0,99):02d}-{random.randint(0,999):03d}"
        address_inserts.append((uid, country, city, street, zipcode))
    insert_many(cursor, "address", ("userID","country","city","street","zipCode"), address_inserts)

    rodo_inserts = []
    for i in range(NUM_RODO):
        consent_id = i + 1
        uid = random.choice(all_user_ids)
        status = random.randint(0,1)
        ts = random_date(2020, 2025)
        rodo_inserts.append((consent_id, uid, status, ts))
    insert_many(cursor, "RODO", ("consent_id","userID","status","timestamp"), rodo_inserts)

    # ============================================================
    # FUNKCJA: Wstaw produkt i zwróć productID
    # ============================================================
    def create_product_return_id(name, price, update_date):
        sql = """
        INSERT INTO products (price, productName, priceUpdateDate)
        OUTPUT INSERTED.productID
        VALUES (?, ?, ?)
        """
        cursor.execute(sql, (price, name, update_date))
        row = cursor.fetchone()
        if row is None or row[0] is None:
            raise Exception("INSERT do products się nie powiódł!")
        return int(row[0])

    # ============================================================
    # 4. Generujemy 3 rodzaje produktów: Kursy, Webinary, Studia
    # ============================================================
    course_titles_pool = [
        "Kurs Python – od podstaw", "Kurs Java dla Początkujących",
        "Kurs Data Science", "Kurs SQL i Bazy Danych",
        "Kurs Excel Zaawansowany", "Kurs Analiza Danych w Pythonie",
        "Kurs Frontend (HTML/CSS/JS)", "Kurs C++ Embedded",
        "Kurs WordPress", "Kurs Docker i Kubernetes",
        "Kurs Machine Learning", "Kurs Statystyka dla Programistów"
    ]
    webinar_titles_pool = [
        "Webinar Marketing Online", "Webinar Data Visualization",
        "Webinar Scrum w Praktyce", "Webinar RPA w Firmie",
        "Webinar Big Data w Chmurze", "Webinar Podstawy ML",
        "Webinar Bezpieczeństwo w Sieci", "Webinar JavaScript nowości ES6+",
        "Webinar DevOps – wprowadzenie"
    ]
    study_names_pool = [
        "Informatyka Stosowana", "Zarządzanie", "Mechanika i Budowa Maszyn",
        "Elektronika i Telekomunikacja", "Automatyka i Robotyka", "Matematyka",
        "Filologia Angielska", "Ekonomia", "Energetyka", "Sztuczna Inteligencja",
        "Fizyka Techniczna", "Chemia Medyczna"
    ]

    course_product_ids = []
    webinar_product_ids = []
    studies_product_ids = []

    # Kursy:
    chosen_course_titles = []
    for _ in range(NUM_COURSES):
        base_title = random.choice(course_titles_pool)
        ctitle = f"{base_title} - edycja {random.randint(1,99)}"
        chosen_course_titles.append(ctitle)

    for title in chosen_course_titles:
        price = round(random.uniform(100, 3000), 2)
        pdate = random_datetime(2022, 2024)
        pid = create_product_return_id(title, price, pdate)
        course_product_ids.append(pid)

    # Webinary:
    chosen_webinar_titles = []
    for _ in range(NUM_WEBINARS):
        wtitle = random.choice(webinar_titles_pool)
        wtitle += f" (edycja {random.randint(1,50)})"
        chosen_webinar_titles.append(wtitle)

    for wtitle in chosen_webinar_titles:
        price = round(random.uniform(0, 800), 2)
        pdate = random_datetime(2022, 2024)
        pid = create_product_return_id(wtitle, price, pdate)
        webinar_product_ids.append(pid)

    # Studia (wpisowe):
    chosen_study_titles = []
    for _ in range(NUM_STUDIES):
        sname = random.choice(study_names_pool)
        sname += f" (rok {random.randint(1,5)})"
        chosen_study_titles.append(sname)

    for stitle in chosen_study_titles:
        price = round(random.uniform(500, 5000), 2)
        pdate = random_datetime(2022, 2024)
        pid = create_product_return_id("Wpisowe: " + stitle, price, pdate)
        studies_product_ids.append(pid)

    # ============================================================
    # 5. Tabela Courses
    # ============================================================
    courses_inserts = []
    cursor.execute("SELECT coordinatorID FROM coordinators ORDER BY coordinatorID")
    all_coordinator_ids = [row.coordinatorID for row in cursor.fetchall()]  # ewentualnie to samo co coordinator_ids

    for i in range(NUM_COURSES):
        pid = course_product_ids[i]
        coord_id = random.choice(all_coordinator_ids)
        title = chosen_course_titles[i]
        desc = f"Kurs «{title}». Nauka od podstaw do zagadnień zaawansowanych."
        stdate = random_date(2023, 2025)
        courses_inserts.append((pid, coord_id, title, desc, stdate))

    insert_many(cursor, "Courses",
                ("productID","coordinatorID","title","description","startDate"),
                courses_inserts)

    # ============================================================
    # 6. Tabela Webinars
    # ============================================================
    webinar_inserts = []
    for i in range(NUM_WEBINARS):
        pid = webinar_product_ids[i]
        t_id = random.choice(tutor_ids)
        tr_id = random.choice(translator_ids) if random.random() < 0.3 else None
        wtitle = chosen_webinar_titles[i]
        sdate = random_datetime(2023, 2025)
        edate = sdate + datetime.timedelta(hours=2)
        desc = f"Opis webinaru: {wtitle}"
        rec_url = "https://webinar-recordings.fake/" + str(random.randint(1000,9999))
        lang = random.randint(1, NUM_LANGUAGES)
        webinar_inserts.append((pid, t_id, tr_id, wtitle, sdate, edate, desc, rec_url, lang))

    insert_many(cursor, "Webinars",
        ("productID","tutorID","translatorID","Title","StartDate","endDate",
         "Description","recordingURL","languageID"),
        webinar_inserts
    )

    # ============================================================
    # 7. Tabela studies
    # ============================================================
    studies_inserts = []
    for i in range(NUM_STUDIES):
        plimit = random.randint(10, 80)
        sname = chosen_study_titles[i]
        entry_fee_pid = studies_product_ids[i]
        studies_inserts.append((plimit, sname, entry_fee_pid))
    insert_many(cursor, "studies",
                ("placeLimit","studiesName","entryFeeProductID"),
                studies_inserts)

    # ============================================================
    # 8. CourseModules (moduleID bez IDENTITY)
    # ============================================================
    cursor.execute("SELECT courseID FROM Courses ORDER BY courseID")
    course_ids_list = [row.courseID for row in cursor.fetchall()]

    module_titles_for_courses = [
        "Podstawy", "Wprowadzenie do składni", "Struktury danych",
        "Zaawansowane techniki", "Testy jednostkowe", "Optymalizacja kodu",
        "Projekt końcowy", "Przykłady z biblioteki standardowej"
    ]
    course_modules_inserts = []
    module_id_counter = 1
    for _ in range(NUM_COURSE_MODULES):
        c_id = random.choice(course_ids_list)
        t_id = random.choice(tutor_ids)
        mtitle = random.choice(module_titles_for_courses)
        mdate = random_datetime(2023, 2025)
        lang = random.randint(1, NUM_LANGUAGES)
        course_modules_inserts.append((module_id_counter, c_id, t_id, mtitle, mdate, lang))
        module_id_counter += 1

    insert_many(cursor, "CourseModules",
                ("moduleID","courseID","tutorID","moduleTitle","moduleDate","languageID"),
                course_modules_inserts)

    # ============================================================
    # 9. studyModules (moduleID = IDENTITY)
    # ============================================================
    cursor.execute("SELECT studiesID FROM studies ORDER BY studiesID")
    studies_ids_list = [row.studiesID for row in cursor.fetchall()]

    module_titles_for_studies = [
        "Wprowadzenie do kierunku", "Zagadnienia zaawansowane", "Projekt semestralny",
        "Laboratorium praktyczne", "Seminarium badawcze", "Warsztaty specjalistyczne",
        "Egzamin próbny", "Analiza przypadków"
    ]
    study_modules_inserts = []
    for _ in range(NUM_STUDY_MODULES):
        sid = random.choice(studies_ids_list)
        coord_id = random.choice(coordinator_ids)
        t = random.choice(module_titles_for_studies)
        d = f"Opis modułu: {t}"
        study_modules_inserts.append((sid, t, d, coord_id))
    insert_many(cursor, "studyModules",
                ("studiesID","moduleTitle","description","coordinatorID"),
                study_modules_inserts)

    # ============================================================
    # 10. meeting
    # ============================================================
    meeting_inserts = []
    for _ in range(NUM_MEETINGS):
        tut_id = random.choice(tutor_ids)
        sd = random_datetime(2023, 2025)
        ed = sd + datetime.timedelta(hours=random.randint(1,4))
        lang = random.randint(1, NUM_LANGUAGES)
        tr_id = random.choice(translator_ids) if random.random() < 0.2 else None
        meeting_inserts.append((tut_id, sd, ed, lang, tr_id))
    insert_many(cursor, "meeting",
                ("tutorID","startDate","endDate","languageID","meetingTranslator"),
                meeting_inserts)

    cursor.execute("SELECT meetingID FROM meeting ORDER BY meetingID")
    all_meeting_ids = [row.meetingID for row in cursor.fetchall()]

    # ============================================================
    # 11. studySessions -> osobny produkt "Sesja ..."
    # ============================================================
    cursor.execute("SELECT studiesID, moduleID FROM studyModules ORDER BY studiesID, moduleID")
    all_study_modules = [(row.studiesID, row.moduleID) for row in cursor.fetchall()]

    study_session_inserts = []
    study_session_product_map = []
    num_sessions_to_generate = min(NUM_STUDY_SESSIONS, len(all_meeting_ids))

    def create_study_session_product(studies_id, module_id):
        prod_name = f"Sesja (studia {studies_id}, moduł {module_id})"
        price = round(random.uniform(50, 600), 2)
        pdate = random_datetime(2022, 2024)
        return create_product_return_id(prod_name, price, pdate)

    for _ in range(num_sessions_to_generate):
        sid, modid = random.choice(all_study_modules)
        mid = random.choice(all_meeting_ids)
        p_id = create_study_session_product(sid, modid)
        study_session_product_map.append((sid, modid, mid, p_id))

    for (sid, modid, mid, p_id) in study_session_product_map:
        study_session_inserts.append((mid, p_id, sid, modid))

    insert_many(cursor, "studySessions",
                ("meetingID","productID","studiesID","moduleID"),
                study_session_inserts)

    # Zbieramy wszystkie productID
    all_product_ids = []
    all_product_ids.extend(course_product_ids)
    all_product_ids.extend(webinar_product_ids)
    all_product_ids.extend(studies_product_ids)
    for (_, _, _, p) in study_session_product_map:
        all_product_ids.append(p)

    # ============================================================
    # 12. Stationary, OnlineSync, onlineAsync
    # ============================================================
    chosen_stationary = random.sample(all_meeting_ids, min(NUM_STATIONARY_MEETINGS, len(all_meeting_ids)))
    st_inserts = []
    for mid in chosen_stationary:
        room_id = random.choice(all_room_ids)
        st_inserts.append((mid, room_id))
    insert_many(cursor, "StationaryMeeting", ("meetingID","room"), st_inserts)

    remain_after_stat = list(set(all_meeting_ids) - set(chosen_stationary))
    chosen_sync = random.sample(remain_after_stat, min(NUM_ONLINE_SYNC_MEETINGS, len(remain_after_stat)))
    sync_inserts = []
    for mid in chosen_sync:
        link = f"https://live-sync.fake/{random.randint(1000,9999)}"
        sync_inserts.append((mid, link))
    insert_many(cursor, "OnlineSyncMeeting", ("meetingID","link"), sync_inserts)

    remain_after_sync = list(set(remain_after_stat) - set(chosen_sync))
    chosen_async = random.sample(remain_after_sync, min(NUM_ONLINE_ASYNC_MEETINGS, len(remain_after_sync)))
    async_inserts = []
    for mid in chosen_async:
        url = f"https://async.fake/{random.randint(1000,9999)}"
        async_inserts.append((mid, url))
    insert_many(cursor, "onlineAsyncMeeting", ("meetingID","recordingURL"), async_inserts)

    # ============================================================
    # 13. moduleMeetings (z kluczem PK(meetingID) => 1 spotkanie = 1 moduł)
    #    Ograniczamy się do `NUM_MODULE_MEETINGS` unikatowych meetingID.
    # ============================================================
    # Ponieważ PK jest (meetingID), nie możemy dać 2 wierszy z tym samym meetingID.
    # Wybieramy losowo "NUM_MODULE_MEETINGS" meetingów i przypisujemy je do modułów.
    cursor.execute("SELECT moduleID FROM CourseModules ORDER BY moduleID")
    all_course_module_ids = [row.moduleID for row in cursor.fetchall()]

    random.shuffle(all_meeting_ids)
    limit_mm = min(NUM_MODULE_MEETINGS, len(all_meeting_ids))
    module_meetings_inserts = []
    for i in range(limit_mm):
        # 1 do 1
        m_id = all_meeting_ids[i]
        mod_id = random.choice(all_course_module_ids)
        # kolumny w moduleMeetings: (moduleID, meetingID)
        module_meetings_inserts.append((mod_id, m_id))

    insert_many(cursor, "moduleMeetings", ("moduleID","meetingID"), module_meetings_inserts)

    # ============================================================
    # 14. meetingAttendance (1500 rekordów), Substitution
    # ============================================================
    ma_pairs = set()
    while len(ma_pairs) < NUM_MEETING_ATTENDANCE:
        mid = random.choice(all_meeting_ids)
        sid = random.choice(student_ids)
        ma_pairs.add((sid, mid))

    ma_inserts = []
    for (sid, mid) in ma_pairs:
        att = random.randint(0, 1)
        ma_inserts.append((sid, mid, att))
    insert_many(cursor, "meetingAttendance",
                ("studentID","meetingID","attendance"),
                ma_inserts)

    subs_inserts = []
    for _ in range(NUM_SUBSTITUTION):
        mid = random.choice(all_meeting_ids)
        subt = random.choice(tutor_ids)
        reason = "Zastępstwo spowodowane nagłą nieobecnością"
        subs_inserts.append((mid, subt, reason))
    insert_many(cursor, "Substitution", ("meetingID","substituteTutorID","reason"), subs_inserts)

    # ============================================================
    # 15. ProductPriceHistory
    # ============================================================
    pph_inserts = []
    for pid in all_product_ids:
        for _ in range(NUM_PRICE_HISTORY_PER_PRODUCT):
            sd = random_datetime(2021, 2022)
            ed = sd + datetime.timedelta(days=random.randint(30, 300))
            old_price = round(random.uniform(50, 5000), 2)
            pph_inserts.append((pid, old_price, sd, ed))
    insert_many(cursor, "ProductPriceHistory",
                ("productID","price","startDate","endDate"),
                pph_inserts)

    # ============================================================
    # 16. Koszyki i Zamówienia
    # ============================================================
    cart_inserts = []
    for _ in range(NUM_CARTS):
        stid = random.choice(student_ids)
        cart_inserts.append((stid,))
    insert_many(cursor, "cart", ("studentID",), cart_inserts)

    cursor.execute("SELECT cartID FROM cart ORDER BY cartID")
    all_cart_ids = [row.cartID for row in cursor.fetchall()]

    cart_details_inserts = set()
    while len(cart_details_inserts) < NUM_CART_DETAILS:
        c_id = random.choice(all_cart_ids)
        p_id = random.choice(all_product_ids)
        cart_details_inserts.add((c_id, p_id))
    insert_many(cursor, "cartDetails", ("cartID","productID"), list(cart_details_inserts))

    orders_inserts = []
    for _ in range(NUM_ORDERS):
        stid = random.choice(student_ids)
        o_date = random_datetime(2022, 2025)
        orders_inserts.append((stid, o_date))
    insert_many(cursor, "orders", ("studentID","orderDate"), orders_inserts)

    cursor.execute("SELECT orderID FROM orders ORDER BY orderID")
    all_order_ids = [row.orderID for row in cursor.fetchall()]

    order_details_inserts = set()
    while len(order_details_inserts) < NUM_ORDER_DETAILS:
        o_id = random.choice(all_order_ids)
        p_id = random.choice(all_product_ids)
        order_details_inserts.add((o_id, p_id))
    insert_many(cursor, "orderDetails", ("orderID","productID"), list(order_details_inserts))

    payment_inserts = []
    for _ in range(NUM_ORDER_PAYMENTS):
        exc = random.randint(0,1)
        status = random.randint(0,1)
        adv = random.randint(0,1)
        oid = random.choice(all_order_ids)
        p_date = random_datetime(2022, 2025)
        link = f"https://platnosc.fake/{random.randint(1000,9999)}"
        payment_inserts.append((exc, status, oid, adv, p_date, link))
    insert_many(cursor, "OrderPayment",
        ("exception","PaymentStatus","orderID","advance","paymentDate","link"),
        payment_inserts)

    # ============================================================
    # 17. CourseAccess, courseModulesPassed (zwiększone)
    # ============================================================
    cursor.execute("SELECT courseID FROM Courses ORDER BY courseID")
    all_course_ids = [row.courseID for row in cursor.fetchall()]

    ca_pairs = set()
    while len(ca_pairs) < NUM_COURSE_ACCESS:
        c_id = random.choice(all_course_ids)
        s_id = random.choice(student_ids)
        ca_pairs.add((c_id, s_id))

    ca_inserts = []
    for (c_id, s_id) in ca_pairs:
        start_d = random_datetime(2023, 2025)
        end_d = start_d + datetime.timedelta(days=30)
        ca_inserts.append((c_id, s_id, start_d, end_d))
    insert_many(cursor, "CourseAccess",
                ("courseID","studentID","accessStartDate","accessEndDate"),
                ca_inserts)

    cursor.execute("SELECT moduleID, courseID FROM CourseModules")
    all_course_modules = [(row.moduleID, row.courseID) for row in cursor.fetchall()]

    cmp_inserts = set()
    while len(cmp_inserts) < NUM_COURSE_MODULES_PASSED:
        mod_id, c_id = random.choice(all_course_modules)
        s_id = random.choice(student_ids)
        cmp_inserts.add((mod_id, s_id))
    insert_many(cursor, "courseModulesPassed",
                ("moduleID","studentID"),
                list(cmp_inserts))

    # ============================================================
    # 18. WebinarAccess, WebinarAttendance (zwiększone)
    # ============================================================
    cursor.execute("SELECT webinarID FROM Webinars ORDER BY webinarID")
    all_webinar_ids = [row.webinarID for row in cursor.fetchall()]

    wa_inserts = []
    for _ in range(NUM_WEBINAR_ACCESS):
        w_id = random.choice(all_webinar_ids)
        s_id = random.choice(student_ids)
        sd = random_datetime(2023, 2025)
        ed = sd + datetime.timedelta(days=30)
        wa_inserts.append((s_id, w_id, sd, ed))
    insert_many(cursor, "WebinarAccess",
                ("studentID","webinarID","accessStartDate","accessEndDate"),
                wa_inserts)

    watt_inserts = set()
    while len(watt_inserts) < NUM_WEBINAR_ATTENDANCE:
        w_id = random.choice(all_webinar_ids)
        s_id = random.choice(student_ids)
        watt_inserts.add((s_id, w_id))
    insert_many(cursor, "WebinarAttendance",
                ("studentID","webinarID"),
                list(watt_inserts))

    # ============================================================
    # 19. studiesParticipants, studyModuleParticipants,
    #     extraStudySessionsParticipants
    # ============================================================
    sp_inserts = set()
    while len(sp_inserts) < NUM_STUDIES_PARTICIPANTS:
        sid = random.choice(studies_ids_list)
        stid = random.choice(student_ids)
        sp_inserts.add((sid, stid))
    insert_many(cursor, "studiesParticipants",
                ("studiesID","studentID"),
                list(sp_inserts))

    cursor.execute("SELECT studiesID, moduleID FROM studyModules ORDER BY studiesID, moduleID")
    all_study_modules = [(row.studiesID, row.moduleID) for row in cursor.fetchall()]

    smp_inserts = set()
    while len(smp_inserts) < NUM_STUDY_MODULE_PARTICIPANTS:
        (st_id, mod_id) = random.choice(all_study_modules)
        s_id = random.choice(student_ids)
        smp_inserts.add((s_id, st_id, mod_id))
    insert_many(cursor, "studyModuleParticipants",
                ("studentID","studiesID","moduleID"),
                list(smp_inserts))

    cursor.execute("SELECT studiesID, meetingID, moduleID FROM studySessions")
    valid_study_sessions = [(row.studiesID, row.meetingID, row.moduleID) for row in cursor.fetchall()]

    essp_inserts = set()
    desired_count = min(len(valid_study_sessions)//2, 50)
    while len(essp_inserts) < desired_count:
        sss = random.choice(valid_study_sessions)
        stid = random.choice(student_ids)
        essp_inserts.add((sss[0], sss[1], sss[2], stid))
    insert_many(cursor, "extraStudySessionsParticipants",
                ("studiesID","meetingID","moduleID","studentID"),
                list(essp_inserts))

    # ============================================================
    # 20. internship + internshipMeeting
    # ============================================================
    internship_inserts = []
    for _ in range(NUM_INTERNSHIP):
        sid = random.choice(studies_ids_list)
        sd = random_date(2023, 2025)
        ed = sd + datetime.timedelta(days=14)
        internship_inserts.append((sid, sd, ed))
    insert_many(cursor, "internship", ("studiesID","startDate","endDate"), internship_inserts)

    cursor.execute("SELECT internshipID FROM internship ORDER BY internshipID")
    all_internship_ids = [row.internshipID for row in cursor.fetchall()]

    im_inserts = []
    for _ in range(NUM_INTERNSHIP_MEETING):
        if not all_internship_ids:
            break
        i_id = random.choice(all_internship_ids)
        stid = random.choice(student_ids)
        att = random.randint(0,1)
        im_inserts.append((i_id, stid, att))
    insert_many(cursor, "internshipMeeting",
                ("internshipID","studentID","attendance"),
                im_inserts)

    # ============================================================
    # 21. StudentAchievements
    # ============================================================
    sa_inserts = []
    for _ in range(NUM_STUDENT_ACHIEVEMENTS):
        stid = random.choice(student_ids)
        ach_type = random.choice(["COURSE","STUDY","WEBINAR"])
        if ach_type == "COURSE":
            cursor.execute("SELECT courseID FROM Courses")
            all_course_ids2 = [row.courseID for row in cursor.fetchall()]
            val = random.choice(all_course_ids2)
        elif ach_type == "STUDY":
            val = random.choice(studies_ids_list)
        else:
            val = random.choice(all_webinar_ids)
        cert = random.randint(0,1)
        sa_inserts.append((stid, ach_type, val, cert))
    insert_many(cursor, "StudentAchievements",
                ("studentID","achievementType","achievementIDValue","certificateSent"),
                sa_inserts)

    # ZATWIERDZENIE
    conn.commit()
    conn.close()
    print("Wstawianie danych zakończone sukcesem.")

if __name__ == "__main__":
    main()
