IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name LIKE 'BookQuery')
  BEGIN
    EXECUTE ('CREATE SCHEMA BookQuery');
  END;
GO

IF (Object_Id ('BookQuery.Phrasebanks', 'U') IS NULL)
/**
Summary: >
  This table merely holds wordbanks.
Author: PhilFactor
Date: Thursday, 20 October 2022
Database: Pubs.BookQuery
**/
  CREATE TABLE BookQuery.PhraseBanks
    (keyword NVARCHAR(20) PRIMARY KEY,
     JSONdocument NVARCHAR(MAX));
/* if we need to, we fill it.*/

IF NOT EXISTS
  (SELECT * FROM BookQuery.PhraseBanks WHERE keyword LIKE 'InstantHumanitiesPHD')
  INSERT INTO BookQuery.PhraseBanks (keyword, JSONdocument)
  VALUES
    ('InstantHumanitiesPHD',
     N'{
    "adjective":[
      "carnivalesque", "rhetorical","divided","new","neoliberal", "sustainable","socially-responsible",
	  "multimedia","historical","formalist","gendered","historical","heterotopian", "collective",
	  "cultural","female","transformative","Intersectional","Political","queer","critical","social",
	  "spiritual","visual","Jungian","unwanted","Pre-raphaelite","acquired","gender",
	  "midlife","emotional","coded"
   ],
   "doesSomethingWith":[
      "evokes","explores","describes","summarises","deliniates","traces","relates","characterises","depicts",
	  "focuses on","narrates","educes","draws inspiration from", "tracks the many influences on","meditates on"
   ],
   "interaction":[
      "relationship","affinity","resonance","narrative","interaction"
   ],
   "something":[
      "the body","experiences","archetypes","queerness","gifts","tenets","synesthesia","politics",
	  "subcultures","memories","Oppression","Spaces","Abjection","Telesthesia","Transnationalism",
	  "care","Ambivalence","Neoliberalism","^adjective Identity","Transcendence","Resistance",
	  "performance","Masochism","Spectatorship","play","Masculinity","Aesthetics","Phenomenology",
	  "Blaxpoitation","Plasticity","Annihilation","Identity","Regeneration","Narratives",
	  "Metaphysics","Normativity","Progress","Erasure","gender perception"
   ],
   "note":[
      "This ^book ^doesSomethingWith the ^interaction between ^something and ^something. ^inspiredby, and by ^thinking, new ^feelings are ^made ^terminator","the ^interaction between ^something and ^something in this ^book is ^pretty.  ^inspiredby, new ^feelings which dominate the early chapters ^doesSomethingWith ^something ^terminator.",
	  "It is ^likely that this will ^remain the most ^positive ^book on the subject, balancing as it does the ^interaction between ^something and ^something. ^inspiredby, it ^doesSomethingWith ^something ^terminator.",
       "^tracing influences from ^something, ^something and ^something, the ^book ^doesSomethingWith ^noun through time",
 	  "This ^book provides a ^positive, ^positive introduction to ^adjective ^something ^terminator, with a focus on ^noun., By ^thinking, new ^feelings are ^made ^terminator",
 	  "^verbing ^adjective ^something is ^positive, ^positive and ^positive. This ^book ^doesSomethingWith the ^adjective and ^adjective imperatives of ^adjective ^noun.",
 	  "^positive, ^positive and yet ^positive, this ^book is unusual in that it is ^inspiredby. It will make you appreciate ^verbing ^something ^terminator"
   ],
   "book":[
	   "book","book","^positive book","^positive exposition","booklet","republished series of lectures",
	   "dissertation","^positive compilation","^positive work","volume","^positive monograph","tract",
	   "thesis"
   ],
   "likely":["probable","likely","quite possible","debatable","inevitable","a done deal",
       "probably just a matter of time","in the balance","to be expected"
   ],
   "tracing":["Tracing","tracking","following","uncovering","trailing","investigatiing","exploring"
   ],
   "remain":["estabilsh itself as","be accepted as","remain","be hailed as","be received by the public as",
      "be recommended as","become"
   ],
   "pretty":["a source of ^positive insights","a ^positive reference","a ^positive statement",
      "demanding but ^positive"
   ],
   "positive":["comprehensive","challenging","exciting","discoursive","interesting","stimulating","evocative",
      "nostalgic","heartwarming","penetrating","insightful","gripping","unusual","didactic","instructive",
	  "educative","informative","edifying","enlightening","illuminating","accessible","effective"
   ],
   "thinking":["methodical structuring of the ^something and ^something",
      "balancing the intricate issues, especially the ^adjective ^something",
      "steering clear of the obvious fallacies in their thinking about ^adjective ^something"
   ],
   "inspiredby":[
      "with a nod to both ^source and ^source",
	  "It draws inspiration from influences as diverse as ^source and ^source",
	  "With influences as diverse as as ^source and ^source",
	  "Drawing from sources such as ^source, ^source and ^source as inspiration",
	  "Taking ideas from writers as diverse as as ^writer and ^writer"
   ],
   "source":[
      "Impressionism","Nihilism","left-bank decedence","Surrealism","Psycholinguistics",
      "Post-modermnism","Deconstructionism","Empiricism","Existentialism",
      "dialectical materialism","feminist philosophy","deontological ethics","Critical Realism",
      "Christian Humanism","Anarchist schools of thought","Eleatics","Latino philosophy",
      "the Marburg School","the Oxford Franciscan school","platonic epistemology","process philosophy",
      "Shuddhadvaita"
   ],
   "writer":["Edward Abbey","JG Ballard","Henry James","Kurt Vonnegut","Evelyn Waugh","Wyndham Lewis",
      "T E Lawrence","Timothy Leary","Hugh MacDiarmid","William Faulkner","Gabriel Garcia Marquez",
	  "Henrik Ibsen","Franz Kafka","Mary Wollstonecraft","Henry David Thoreau"
   ],
   "terminator":[
      "as a means of ^adjective and ^adjective ^something","representing ^adjective claims to ^something",
	  "as a site of ^something","as ^something","without a connection","as ^adjective ^something",
	  "as ^adjective ^something and ^something","as ^adjective mediators",
	  "and the gendering of space in the gilded age","as ^adjective justice","as violence",
	  "in the digital streaming age","in an ^adjective framework",
	  "in new ^adjective media","and the violence of ^something","as a form of erasure",
	  "and the negotiation of ^something","signifying ^adjective relationships in ^adjective natures",
	  "as a site of ^adjective contestation","in crisis","as ^adjective devices","through a ^adjective lens"
   ],
   "title":[
      "^verbing ^something ^terminator.","^noun ^terminator.",
	  "^verbing ^adjective ^something: The ^adjective ^noun."
   ],
   "verbing":[
      "situating","transforming","disempowering","reinterpreting","critiquing","a reading of",
	  "activating","the politics of","representations of","interrogating","erasing","redefining",
	  "identifying","reimagining","performing","the legibility of","democratizing","de-centering",
	  "gender and","debating","signaling","embodying","building","the role of","historicizing",
	  "repositioning","destabilizing","mapping","eliminating"
   ],
   "noun":[
      "Genre and Justice","^verbing Uncertainty","Identity","^something and ^something of ^something",
	  "Bodies and Static Worlds","^noun of ^adjective Spaces","^something as resistance,",
	  "Modes of witnessing","representations of trauma","concept of freedom","multimedia experiences",
	  "bodies","theory and empirical evidence","ecology of ^something","^adjective Labor Migration",
	  "^something and ^something","^adjective possibilities","^adjective limitations",
	  "aesthetic exchange","Immersion","abstraction","Revolutionary Sexuality","politics and power",
	  "aesthetics","aepresentation","^adjective categories","pluralities","gender","gaze",
	  "forms of ^something","silences","power structures","dissent","^adjective approach","self",
	  "queerness","modes of being","ontology","agency","epistemologies","intertextuality",
	  "Hyper-Extensionality","fields of belonging","hybridization"
   ],
   "feelings":[
      "combinations","tensions","synergies","resonances","harmonies","contradictions","paradoxes",
	  "superimpositions","amalgamations","syntheses"
   ],
   "made":[
      "distilled","manufactured","woven","synthesised","uncovered","determined","observed","portrayed"
   ]
}'  );

GO

CREATE OR ALTER FUNCTION BookQuery.TitleCase (@string NVARCHAR(MAX))
/**
Summary: >
  Capitalise all words five letters and longer. 
  Even if the words are prepositions or conjunctions, 
  lower case all other conjunctions, prepositions and articles
  capitalise first and last word

Author: PhilFactor
Date: 05/01/2020
Database: PhilsScripts
Examples:
   - SELECT  BookQuery.TitleCase('god save her majesty') --God save her majesty
Returns: >
  Returns a copy of the string with only its first character capitalized.
**/
RETURNS NVARCHAR(MAX)
AS
  BEGIN

    DECLARE @StringLength INT, @Start INT, @end INT, @Cursor INT,
            @WordLength INT, @word NVARCHAR(200), @output NVARCHAR(MAX),
            @wordNumber INT;

    SELECT @Cursor = 1, @StringLength = Len (@string), @wordNumber = 0;
    WHILE @Cursor < @StringLength
      BEGIN
        SELECT @Start =
          PatIndex (
            '%[^A-Za-z0-9][A-Za-z0-9%]%',
            ' ' + Substring (@string, @Cursor, 50)) - 1;
        IF @Start < 0 BREAK;
        SELECT @WordLength =
          PatIndex (
            '%[^A-Z''a-z0-9-%]%',
            Substring (@string, @Cursor + @Start + 1, 50) + ' '),
               @wordNumber = @wordNumber + 1,
               @word = Substring (@string, @Cursor + @Start, @WordLength);
        IF @wordNumber = 1 --first word
        OR @word NOT IN
        ('of', 'in', 'to', 'for', 'with', 'on', 'at', 'from', 'by', 'as',
         'into', 'like', 'over', 'out', 'and', 'that', 'but', 'or', 'as',
         'if', 'when', 'than', 'so', 'nor', 'like', 'once', 'now', 'a', 'an',
         'the')
          SELECT @string =
            Stuff (
              @string,
              @Cursor + @Start,
              1,
              Upper (Substring (@string, @Cursor + @Start, 1)));
        SELECT @Cursor = @Cursor + @Start + @WordLength + 1,
               @wordNumber = @wordNumber + 1;
      END;
    RETURN @string;
  END;
GO

Create OR ALTER VIEW BookQuery.RAN
AS
  /**
Summary: >
  All this does is to deceive any function into dealing with a
  NewId() in a function. It causes the function to be indeterminant
  and therefore will execute for each row

Author: PhilFactor
Date: 05/11/2020
Database: PhilsScripts
Examples:
  - SELECT number, firstname 
      from ran 
      cross join AdventureWorks2016.person.person
   Returns: >
  Returns a different GUID for every line.
**/
  /* */
  SELECT NewId () AS number;
GO

CREATE OR ALTER FUNCTION BookQuery.SentenceFrom
  (@JsonData NVARCHAR(MAX),  --the collection of objects, each one
                             -- consisting of arrays of strings. If a word is prepended by  a 
                             -- ^ character, it is the name of the object whose value is the array 
                             -- of strings
   @Reference NVARCHAR(100), --the JSON reference to the objecvt containing the
                             -- list of strings to choose one item from.
   @level INT = 5            --the depth of recursion allowed . 0 means don't recurse.
)
/**
Summary: > 
   this function takes a json document that describes all the
   alternative components
   of a string and from it, it returns a string.
   basically, you give it a list of alternatives and it selects one of them. However
   if you put in the name of an array as one of the alternatives,rather than a word,
   it will, if it selects it, treat it as a new reference and will select one of 
   these alternatives.
Author: PhilFactor
Date: 05/11/2020
Database: PhilsScripts
Examples:
   - select BookQuery.SentenceFrom('{
     "name":[ "^prefix ^firstname ^lastname ^suffix",
	   "^prefix ^firstname ^lastname","^firstname ^lastname"
      ],
      "prefix":["Mr","Mrs","Miss","Sir","Dr","professor"
      ],
      "firstname":["Dick","Bob","Ravi","Jess","Karen"
      ],
      "lastname":["Stevens","Payne","Boyd","Sims","Brown"
      ],
      "suffix":["3rd","MA","BSc","","","","",""
      ]
    }
    ','$.name',5)
Returns: >
  a randomised string.
**/

RETURNS NVARCHAR(MAX)
AS
  BEGIN
    IF Coalesce (@level, -1) < 0 RETURN 'too many levels'; /* if there is mutual 
references, this can potentially lead to a deadly embrace. This checks for that */
    IF IsJson (@JsonData) <> 0 --check that the data is valid
      BEGIN
        DECLARE @Choices TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @words TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @ii INT, @iiMax INT, @Output NVARCHAR(MAX);
        DECLARE @Endpunctuation VARCHAR(80); -- used to ensure we don't lose end punctuation
        DECLARE @SingleWord NVARCHAR(800), @ValidJsonList NVARCHAR(800);
        --we check for a missing or global reference and use the first object
        IF Coalesce (@Reference, '$') = '$'
          SELECT TOP 1 @Reference = '$.' + [Key] --just get the first
            FROM OpenJson (@JsonData, '$')
            WHERE Type = 4;
        INSERT INTO @Choices ([KEY], value) --put the choices in a temp table
          SELECT [Key], Value FROM OpenJson (@JsonData, @Reference) WHERE
          Type = 1;
        -- if there was an easy way of getting the length of the array then we
        --could use JSON_VALUE ( expression , path ) to get the element   
        -- and get the chosen string
        DECLARE @string NVARCHAR(4000) =
                  (SELECT TOP 1 value FROM @Choices CROSS JOIN RAN ORDER BY
                   RAN.number);
        SELECT @ValidJsonList =
          N'["' + Replace (String_Escape (@string, 'json'), ' ', '","')
          + N'"]';
        IF IsJson (@ValidJsonList) = 0 RETURN N'invalid reference- '
                                              + @ValidJsonList;
        --now we examine each word in the string to see if it is reference
        --to another array within the JSON.
        INSERT INTO @words ([KEY], value) SELECT [Key], Value FROM
                                          OpenJson (@ValidJsonList, '$');
        IF @@RowCount = 0 RETURN @ValidJsonList + ' returned no words';
        SELECT @ii = 0, @iiMax = Max ([KEY]) FROM @words;
        -- we now loop through the words either treating the words as strings
        -- or symbols representing arrays
        WHILE (@ii < (@iiMax + 1))
          BEGIN
            SELECT @SingleWord = value FROM @words WHERE [KEY] = @ii;
            IF @@RowCount = 0
              BEGIN
                SELECT @Output =
                N'no words in' + N'["' + Replace (@string, ' ', '","')
                + N'"]';
                RETURN @Output;
              END;
            SELECT @ii = @ii + 1;
            IF Left(LTrim (@SingleWord), 1) = '^' -- it is a reference
              BEGIN -- nick out the '^' symbol
                SELECT @Reference = '$.' + Stuff (@SingleWord, 1, 1, ''),
                       @Endpunctuation = '';
                WHILE Reverse (@Reference) LIKE '[:;.,-_()]%'
                  BEGIN --rescue any punctuation after the symbol
                    DECLARE @End INT = Len (@Reference);
                    SELECT @Endpunctuation = Substring (@Reference, @End, 1);
                    SELECT @Reference = Substring (@Reference, 1, @End - 1);
                  END; --and we call it recursively
                IF @level > 0
                  SELECT @Output =
                    Coalesce (@Output + ' ', '')
                    + BookQuery.SentenceFrom (
                        @JsonData, @Reference, @level - 1) + @Endpunctuation;
              END;
            -- otherwise it is plain sailing. Would that it were always
            -- that simple
            ELSE SELECT @Output = Coalesce (@Output + ' ', '') + @SingleWord;
          END;
      END;
    ELSE SELECT @Output = N'sorry. Error in the JSON';
    RETURN Upper (Substring (@Output, 1, 1)) + Substring (@Output, 2, 8000); --and return whatever (it could be a novel!)
  END;
GO

CREATE OR ALTER FUNCTION BookQuery.author ()
RETURNS NVARCHAR(100)
AS
  BEGIN
    DECLARE @JSONNameData NVARCHAR(MAX) =
      N'{
  "fullname":[
    "Mr ^malename",
	"Mrs ^femalename",
	"Ms ^femalename",
	"Dr ^name",
	"Dr ^name",
	"Sir ^malename",
	"Lady ^femalename",
	"Mr ^malename",
    "Miss ^femalename",
	"Professor ^name",
	"Captain ^name",
	"Bishop ^name",
	"Mr ^malename",
	"Mrs  ^femalename",
	"Ms ^femalename"
   ],
  "malename":[
      "^malefirstname ^lastname ^suffix",
      "^malefirstname ^lastname",
      "^malefirstname ^lastname"
   ],
  "femalename":[
      "^femalefirstname ^lastname ^suffix",
      "^femalefirstname ^lastname",
      "^femalefirstname ^lastname"
   ],
  "name":["^malename","^femalename"],
  "malefirstname":["Noah","Oliver","William","Elijah","James","Benjamin",
   "Lucas,","Mason","Ethan","Alexander","Henry","Jacob","Michael","Daniel",
   "Logan","Jackson","Sebastian","Jack","Aiden"
   ],
  "femalefirstname":["Olivia","Emma","Ava","Sophia","Isabella","Charlotte",
   "Amelia","Mia","Harper","Evelyn","Abigail","Emily","Ella","Elizabeth",
   "Camila","Luna","Sofia","Avery","Mila","Aria","Scarlett","Penelope",
   "Layla","Chloe","Victoria","Madison","Eleanor","Grace","Nora","Riley"
   ],
  "lastname":["Smith","Johnson","Patel","Williams","Brown","Jones","Garcia",
   "Miller","Davis","Rodriguez","Martinez","Hernandez","Lopez","Gonzalez",
   "Wilson","Anderson","Li","Thomas","Taylor","Moore","Jackson","Martin","Lee",
   "Perez","Thompson","White","Wong","Harris","Sanchez","Clark","Ramirez","Lewis",
   "Robinson","Walker","Young","Allen","King","Wright","Scott","Torres",
   "Nguyen","Hill","Flores","Green" ],
   "suffix":[
      "3rd","MA","BSc","","","","",""
   ]
}'  ;
    RETURN BookQuery.SentenceFrom (@JSONNameData, '$.fullname', 5);
  END;

GO


CREATE OR ALTER FUNCTION BookQuery.GetListOfBooks (@SearchString NVARCHAR(40))
/**
Summary: >
Returns forty sample books
Author: PhilFactor
Date: Thursday, 20 October 2022
Database: Pubs
Examples:
   - SELECT * FROM BookQuery.GetListOfBooks ('dfgd');
Returns: >
  table of pretend books 
**/
RETURNS @returntable TABLE
  (Title NVARCHAR(100),
   Notes NVARCHAR(MAX),
   Author NVARCHAR(50))
AS
  BEGIN
    DECLARE @JSONQuery NVARCHAR(MAX) =
              (SELECT JSONdocument FROM BookQuery.PhraseBanks WHERE
               keyword = 'InstantHumanitiesPHD');
    INSERT INTO @returntable (Title, Notes, Author)
      SELECT TOP 20 BookQuery.TitleCase (
                      BookQuery.SentenceFrom (@JSONQuery, '$.title', 5)) AS title,
                    BookQuery.SentenceFrom (@JSONquery, '$.note', 5) AS notes,
                    BookQuery.author () AS author
        FROM sys.objects;
    RETURN;
  END;
go


