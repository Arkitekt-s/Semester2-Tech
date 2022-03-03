--1.	How many songs are there in the playlist “Grunge”?

select count(*) from playlist left join playlisttrack on playlist.playlistid=playlisttrack.playlistid where Name='Grunge';
--2.	Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.

select * from artist where name like '%Jack%' and name like '%John%' and name not like '%Martin%';

--3.	For each country where some invoice has been issued, show the total invoice monetary amount, but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.

select  invoice.BillingCountry, sum(invoice.Total) from invoice group by invoice.BillingCountry
having sum(invoice.Total)>100 order by sum(invoice.Total) desc ;


--4.	Get the phone number of the boss of those employees who have given support to clients who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.

select  employee.Phone as phonenumber,employee.FirstName as name,employee.Title
as 'boss of employee' from employee where employee.EmployeeId=(

select distinct  employee.Reportsto  from employee
join customer on employee.EmployeeId = customer.SupportRepId
inner join invoice on customer.CustomerId = invoice.CustomerId
inner join invoiceline i on invoice.InvoiceId = i.InvoiceId
inner join track t on i.TrackId = t.TrackId
inner join mediatype m on t.MediaTypeId = m.MediaTypeId
where Composer ='Miles Davis'and m.Name='MPEG Audio File') ;

--5.	Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova” genre whose title starts by the word “Samba”.#

select distinct album.AlbumId, album.Title
from album
join track t on album.AlbumId = t.AlbumId
join genre g on t.GenreId = g.GenreId
where g.Name='Bossa Nova' and t.Name like 'samba%';




--6.	For each genre, show the average length of its songs in minutes (without indicating seconds). Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.

select track.GenreId, AVG(Milliseconds/60000) AS minutes  from track
where GenreId in (select distinct GenreId from track where Milliseconds>1800000)
group by GenreId;
select distinct GenreId from track where Milliseconds>1800000;
--7.	How many client companies have no state?

select count(*) from customer where state is null;

--8.	For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients from these countries s/he has given support, only when this number is higher than 6. Sort the query by number of clients. Regarding the employee, show his/her first name and surname separated by a space. Use “Employee” and “Clients” as headers.

select employee.firstname, employee.lastname, count(*) as employee
from employee left join customer on
employee.employeeid=customer.supportrepid where customer.country in ('USA', 'canada', 'mexico') group by employee.firstname, employee.lastname having count(*) >6 order by count(*) desc;
--9.	For each client from the “USA”, show his/her surname and name (concatenated and separated by a comma) and their fax number. If they do not have a fax number, show the text “S/he has no fax”. Sort by surname and first name.

select customer.firstname, customer.lastname,customer.fax from customer where country='USA' AND customer.fax is not null;
--10.For each employee, show his/her first name, last name, and their age at the time they were hired.

select employee.firstname,employee.lastname,(YEAR(employee.HireDate)-YEAR(employee.BirthDate)) as age from employee;
