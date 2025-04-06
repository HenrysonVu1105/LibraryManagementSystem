library_management_system/
│
├── app.py          # Main Flask application file
├── sql/            # All sql implementations 
│
├── templates/      # HTML templates
│   ├── index.html
│   ├── students.html
│   ├── librarians.html
│   ├── books.html
│   ├── add_student.html
│   ├── add_librarian.html
│   ├── add_book.html
│   ├── error.html    # General error page
│   # ... other template files
│ 
└── README.md

before executing app.py at ./frontend/app.py, make sure to install flask, cx_Oracle
** important ** 
after installing packages, Download the Oracle Instant Client from 
https://www.oracle.com/database/technologies/instant-client/downloads.html

extract it to a system directory and add the dirctory to system environment path variable
restart the system after that, voila!!!, now run the app.py file, click on the localhost link, and there is your webpage 