1 install mysql

2 start service

2 mysql
 > use mysql
 > select host,user from user;
 > SET PASSWORD FOR 'root'@'localhost' = PASSWORD('pwd');
 > SET PASSWORD FOR 'root'@'localhost.localdomain' = PASSWORD('pwd');
 > SET PASSWORD FOR 'root'@'::1' = PASSWORD('pwd');
 > SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('pwd');
 > DROP USER ''@'localhost';
 > DROP USER ''@'localhost.localdomain';
 > DROP USER ''@'127.0.0.1';
 > DROP USER ''@'%';
 > FLUSH PRIVILEGES;
 > CREATE DATABASE sdbs_ac;
 > GRANT ALL PRIVILEGES ON `sdbs_ac`.* TO `sdbs_ac`@`localhost` IDENTIFIED BY 'sdbs_ac';
 > FLUSH PRIVILEGES;

3 unzip sdbs_ac.sql.zip

4 mysql -u sdbs_ac -p < sdbs_ac_database.sql

5 mysql -u sdbs_ac -p sdbs_ac < sdbs_ac_table_user.sql



