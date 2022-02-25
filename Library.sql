--1.	Show the members under the name "Jens S." who were born before 1970 that became members of the library in 2013.#
select * from tmember where cName = 'Jens S.' and dBirth < '1970-01-01' and dNewMember > '2013-01-01';

--2.	Show those books that have not been published by the publishing companies with ID 15 and 32, except if they were published before 2000.#
select * from tbook where nPublishingCompanyID not in (15, 32) and nPublishingYear > '2000-01-01';

--3.	Show the name and surname of the members who have a phone number, but no address.#
select cName, cSurname from tmember where cPhoneNo is not null and cAddress is null;

--4.	Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S" (uppercase).#
select cName, cSurname from tauthor where cSurname = 'Byatt' and cName like 'A%S%';

--5.	Show the number of books published in 2007 by the publishing company with ID 32.
select nBookID from tbook where nPublishingYear = '2007' and nPublishingCompanyID = 32;

--6.	For each day of the year 2014, show the number of books loaned by the member with CPR "0305393207";#
select cSignature from tloan where cCPR = '0305393207' and dLoan like '2014-%';

--7.	Modify the previous clause so that only those days where the member was loaned more than one book appear.#
select cSignature from tloan where cCPR = '0305393207' and dLoan like '2014-%' group by dLoan having count(*) > 1;


--8.	Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
select * from tmember order by dNewMember desc, cSurname, cName;

--9.	Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
select cTitle from tbook where nPublishingCompanyID = 32;

--10.Show the name and surname of every author along with the number of books authored by them, but only for authors who have registered books on the database.
select cName, cSurname from tauthor ;

--11.Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
select tauthor.cName,tauthor.cSurname,min(nPublishingYear) as publisher from tauthor left join tauthorship t on tauthor.nAuthorID = t.nAuthorID
inner join tbook t2 on t.nBookID = t2.nBookID group by cName,cSurname order by publisher ;

--12.For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.
select  t2.cTitle,t3.cName,t3.cSurname from tloan left join tmember t3 on tloan.cCPR=t3.cCPR
    left join tbookcopy t on tloan.cSignature = t.cSignature
left join tbook t2 on t.nBookID = t2.nBookID group by t2.cTitle,t3.cSurname,t3.cName;


--13.Repeat exercises 9 to 12 using the modern JOIN notation.



--14.Show all theme names along with the titles of their associated books. All themes must appear (even if there are no books for some particular themes). Sort by theme name.

select t.nThemeID,cName , t2.cTitle from
ttheme   LEFT join tbooktheme t on ttheme.nThemeID = t.nThemeID left join
tbook t2 on t.nBookID = t2.nBookID order by ttheme.cName ASC;

--15.Show the name and surname of all members who joined the library in 2013 along with the title of the books they took on loan during that same year. All members must be shown, even if they did not take any book on loan during 2013. Sort by member surname and name.

select tmember.cName,tmember.cSurname, tmember.dNewMember,t3.cTitle  from tmember
left join tloan t on tmember.cCPR = t.cCPR
inner join tbookcopy t2 on t.cSignature = t2.cSignature inner join
tbook join tbook t3 on t2.nBookID = t3.nBookID and tmember.dNewMember like '2013-%';

--16.Show the name and surname of all authors along with their nationality or nationalities and the titles of their books. Every author must be shown, even though s/he has no registered books. Sort by author name and surname.



--17.Show the title of those books which have had different editions published in both 1970 and 1989.



--18.	Show the surname and name of all members who joined the library in December 2013 followed by the surname and name of those authors whose name is “William”.

--19.	Show the name and surname of the first chronological member of the library using subqueries.

--20.	For each publishing year, show the number of book titles published by publishing companies from countries that constitute the nationality for at least three authors. Use subqueries.

--21.	Show the name and country of all publishing companies with the headings "Name" and "Country".

--22.	Show the titles of the books published between 1926 and 1978 that were not published by the publishing company with ID 32.

--23.	Show the name and surname of the members who joined the library after 2016 and have no address.

--24.	Show the country codes for countries with publishing companies. Exclude repeated values.

--25.	Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".

--26.	Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.

--27.	Show the titles of those books which have never been loaned.

--28.	For each publishing company, show its number of existing books under the heading "No. of Books".

--29.	Show the number of members who took some book on a loan during 2013.

--30.	For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".


