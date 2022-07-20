/* Titles and their authors*/
SELECT title + ' (' + Type + ')' AS titleAndType, au_fname + ' ' + au_lname AS Author,
       'Tel:' + phone + ' ' + address + ', ' + city + ', ' + state
       + '. Zip: ' + zip AS contact
  FROM
  authors, titles, titleauthor
  WHERE
  authors.au_id = titleauthor.au_id
AND titles.title_id = titleauthor.title_id;
GO


