# PostgreSQL-Data-Modeling-DVD-Rental-in-3NF-Star-Schema
Designed and transformed the DVD Rental database from **3NF** to a **Star Schema** in **PostgreSQL** to optimize query performance. Gained hands-on experience with PostgreSQL, **pgAdmin**, **CLI commands**, and data import processes. Learned from Darshil Parmar’s YouTube channel, which covered database setup, design decisions, and best practices for structuring relational data. ([LINK VDO](https://www.youtube.com/watch?v=ViwHbjVtG20&list=PLBJe2dFI4sgukOW6O0B-OVyX9c6fQKJ2N&index=6))

## DVD Rental Dataset

![Blank diagram - Page 2](https://github.com/user-attachments/assets/fdad86df-70c2-4f82-be39-bc30398a08c4)

[The DVD Rental Database](https://neon.tech/postgresql/postgresql-getting-started/postgresql-sample-database) is a sample dataset used to demonstrate PostgreSQL features. It models the business operations of a DVD rental store, including inventory management, customer rentals, payments, and store operations.

The database consists of 15 tables: actor, film, film_actor, category, film_category, store, inventory, rental, payment, staff, customer, address, city, and country.

The relationships between these tables are shown in the ER diagram above.

## Designing Star Schema
In this project, I designed a **star schema** from the DVD rental dataset to improve query performance and simplify data analysis. The diagram below shows the star schema structure.

![Blank diagram - Page 1 (1)](https://github.com/user-attachments/assets/f1a7df8e-0561-41e1-b091-c57dca000850)

## Create Database and Insert data
I created a database named **"dvdrental"** on my local host and imported the dvdrental.tar file using the CLI.

For schema design, I wrote **DDL SQL scripts** to create tables for the star schema and performed **ETL** to extract data from the **3NF database**, transform it, and store it in the star schema format.

All SQL scripts and code are available in this repository.
