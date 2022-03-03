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

select cSignature ,count(*) from tloan where
cCPR = '0305393207' and dLoan like '2014-%' group by dLoan having count(*) > 1;


--8.	Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
select * from tmember order by dNewMember desc, cSurname, cName;

--9.	Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
select cTitle from tbook where nPublishingCompanyID = 32;

--10.Show the name and surname of every author along with the number of books authored by them, but only for authors who have registered books on the database.
select cName, cSurname from tauthor ;

--11.Show the name and surname of all the authors with published books along with the lowest publishing year for their books.

select tauthor.cName,tauthor.cSurname,min(nPublishingYear) as publisher
from tauthor left join tauthorship t on tauthor.nAuthorID = t.nAuthorID
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


select DISTINCT tmember.cName,tmember.cSurname, tmember.dNewMember,t3.cTitle,t.dLoan  from tmember
left join tloan t on tmember.cCPR = t.cCPR
left join tbookcopy t2 on t.cSignature = t2.cSignature
left join tbook  t3 on t2.nBookID = t3.nBookID where
(tmember.dNewMember like '%2013%' and t.dLoan like '%2013%') OR (tmember.dNewMember like '%2013%' AND T.dLoan IS NULL)
order by tmember.cSurname,tmember.cName;




--16.Show the name and surname of all authors along with their nationality or nationalities and the titles of their books. Every author must be shown, even though s/he has no registered books. Sort by author name and surname.
select tauthor.cname, tauthor.cSurname, t2.cName from tauthor
left join tnationality t on tauthor.nAuthorID = t.nAuthorID
left join tcountry t2 on t.nCountryID = t2.nCountryID order by tauthor.cName,tauthor.cSurname;





--17.Show the title of those books which have had different editions published in both 1970 and 1989.
select count(tbook.cTitle), tbook.cTitle, nPublishingYear
from tbook where nPublishingYear ='1989' or nPublishingYear='1970' group by tbook.cTitle having count(tbook.cTitle)>1;

--18.	Show the surname and name of all members who joined the library in December 2013 followed by the surname and name of those authors whose name is “William”.
select  tmember.cname, tmember.csurname,tmember.dNewMember from tmember where tmember.dNewMember like'%2013-12%'
Union
select tauthor.cName ,tauthor.cSurname,null from tauthor where tauthor.cName='william';

--19.	Show the name and surname of the first chronological member of the library using subqueries.
select tmember.cName as 'Name',tmember.cSurname as 'surname'
from tmember where tmember.cName =(select min(cName)from tmember );


--20.	For each publishing year, show the number of book titles published by publishing companies from countries that constitute the nationality for at least three authors. Use subqueries.

select tbook.npublishingyear, count(tbook.cTitle) as 'number of book titles', tbook.npublishingcompanyid
from tbook where nPublishingCompanyID=(select tpublishingcompany.npublishingcompanyid
from tpublishingcompany where tpublishingcompany.nCountryID=
(select tcountry.nCountryID from tcountry where tcountry.nCountryID =(select tnationality.nCountryID
from tnationality where tnationality.nAuthorID >=3)));



--21.	Show the name and country of all publishing companies with the headings "Name" and "Country".


select tpublishingcompany.cName as name ,tpublishingcompany.nCountryID ,t.cName as country
from tpublishingcompany inner join tcountry t on tpublishingcompany.nCountryID = t.nCountryID ;

--22.	Show the titles of the books published between 1926 and 1978 that were not published by the publishing company with ID 32.

select tbook.cTitle,tbook.nPublishingCompanyID,tbook.nPublishingYear
from tbook where nPublishingYear< '1978'and nPublishingYear>'1926' and nPublishingCompanyID!='32';
--23.	Show the name and surname of the members who joined the library after 2016 and have no address.

select tmember.cname , tmember.cSurname,tmember.dNewMember ,tmember.cAddress
from tmember where YEAR (tmember.dNewMember)>='2016' and tmember.cAddress is null;
--24.	Show the country codes for countries with publishing companies. Exclude repeated values.

select distinct tcountry.nCountryID from tcountry inner join
tpublishingcompany on tcountry.nCountryID = tpublishingcompany.nCountryID ;

--25.	Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".

select tbook.cTitle from tbook left join tpublishingcompany on
tbook.nPublishingCompanyID = tpublishingcompany.nPublishingCompanyID where
tbook.cTitle like 'The Tale%' and tpublishingcompany.cName!='Lynch Inc';

--26.	Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.

select distinct ttheme.cname from ttheme inner join tbooktheme on ttheme.nThemeID = tbooktheme.nThemeID
inner join tbook on tbooktheme.nBookID = tbook.nBookID inner join tauthorship t on tbook.nBookID = t.nBookID
inner join tpublishingcompany t2 on tbook.nPublishingCompanyID = t2.nPublishingCompanyID
where t2.cName ='Lynch Inc';


--27.	Show the titles of those books which have never been loaned.

select tbook.cTitle  as 'title of book' ,t.nbookID, t2.dloan from tbook left join tbookcopy t on tbook.nBookID = t.nBookID
left join tloan t2 on t.cSignature = t2.cSignature where t2.cSignature is null ;


--28.	For each publishing company, show its number of existing books under the heading "No. of Books".

select tpublishingcompany.cName as 'name of publishing company', count(tbook.nPublishingCompanyID) as 'No. of Books'
from tpublishingcompany left join tbook on tpublishingcompany.nPublishingCompanyID = tbook.nPublishingCompanyID
group by tpublishingcompany.nPublishingCompanyID;


--29.	Show the number of members who took some book on a loan during 2013.

select count(tmember.cCPR) as member  from tmember join tloan t on tmember.cCPR = t.cCPR where t.dLoan like '%2013%';


--30.	For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".

select tbook.cTitle as 'title of book', count(t.nAuthorID) as 'No. of Authors'
from tbook inner join tauthorship t on tbook.nBookID = t.nBookID group by tbook.cTitle having count(t.nAuthorID)>=2;




