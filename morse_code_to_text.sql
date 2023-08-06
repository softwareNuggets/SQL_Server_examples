--GitHub
--https://github.com/softwareNuggets
--       /SQL_Server_examples
--       /morse_code_to_text.sql
--
--drop function sfn_morse_code_to_text


CREATE FUNCTION sfn_morse_code_to_text (@morse_code VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	-- This variable will hold the translation from Morse code to text.
    DECLARE @translation VARCHAR(MAX) = '';
    
	-- A placeholder for a single Morse code character.
	DECLARE @singleChar CHAR(1);

    -- This is a table that matches letters and numbers to their Morse code equivalents.
    -- It will be used to look up the translation of each Morse code sequence.
    DECLARE @morse_code_table TABLE (
        letter			CHAR(1),
        morse_code		VARCHAR(7)
    );

    -- Here we list the letters from A to Z and numbers from 0 to 9 along with their Morse code.
    -- Each letter/number corresponds to a unique Morse code sequence.
    INSERT INTO @morse_code_table (letter, morse_code)
    VALUES
        ('A', '.-'),	('B', '-...'),	('C', '-.-.'),		('D', '-..'),
        ('E', '.'),     ('F', '..-.'),	('G', '--.'),		('H', '....'),
        ('I', '..'),	('J', '.---'),	('K', '-.-'),		('L', '.-..'),
        ('M', '--'),	('N', '-.'),    ('O', '---'),       ('P', '.--.'),
        ('Q', '--.-'),  ('R', '.-.'),   ('S', '...'),       ('T', '-'), 
        ('U', '..-'),   ('V', '...-'),  ('W', '.--'),       ('X', '-..-'),
        ('Y', '-.--'),  ('Z', '--..'),
		('0', '-----'),('1', '.----'),('2', '..---'),('3', '...--'),('4', '....-'),
		('5', '.....'),('6', '-....'),('7', '--...'),('8', '---..'),('9', '----.'),
		('.', '.-.-.-'),      -- Period
		(',', '--..--'),      -- Comma
		('?', '..--..'),      -- Question mark
		('!', '-.-.--'),      -- Exclamation mark
		('-', '-....-'),      -- Hyphen
		('/', '-..-.'),       -- Slash
		('(', '-.--.'),       -- Left parenthesis
		(')', '-.--.-'),      -- Right parenthesis
		('&', '.-...'),       -- Ampersand
		(':', '---...'),      -- Colon
		(';', '-.-.-.'),      -- Semicolon
		('=', '-...-'),       -- Equal sign
		('+', '.-.-.'),       -- Plus sign
		('_', '..--.-'),      -- Underscore
		('"', '.-..-.'),      -- Double quote
		('$', '...-..-'),     -- Dollar sign
		('@', '.--.-.'),      -- At sign
		(' ', '/');           -- Space (using slash for clarity)


	-- Now, we start processing the input Morse code.
	-- We loop through the Morse code string one segment at a time.
	WHILE LEN(@morse_code) > 0
		BEGIN

			-- A placeholder for a sequence of Morse code characters.
			DECLARE @block VARCHAR(7);

			-- let's find the space character in the @morse_code variable
			DECLARE @spaceIndex INT = CHARINDEX(' ', @morse_code);

			-- if we didn't find a space character, we are probably at
			-- the end of the input, so let's add 1 to the length
			IF @spaceIndex = 0
				SET @spaceIndex = LEN(@morse_code) + 1;

			-- let's assign @block the morse_code pattern up to the space, don't
			-- include the space character
			SET @block = SUBSTRING(@morse_code, 1, @spaceIndex - 1);

			-- notice on line 61, while len(@morse_code)>0
			-- here we modify the contents of @morse_code
			-- removing the "@block" from @morse_code
			-- until @morse_code is empty
			SET @morse_code = LTRIM(SUBSTRING(@morse_code, @spaceIndex, LEN(@morse_code) - @spaceIndex + 1));

			-- Now, we look up the character (letter or number or symbol) from @block.
			SET @singleChar = (
				SELECT letter
				FROM @morse_code_table
				WHERE morse_code = @block
			);
        
			IF @singleChar IS NOT NULL
				SET @translation = @translation + @singleChar;
			ELSE
				SET @translation = @translation + ' ';  -- replace unknown character with a space
		END;

	RETURN @translation;
END;






declare @morse_code VARCHAR(MAX) = '----- .---- ..---';
print @morse_code

DECLARE @spaceIndex INT = CHARINDEX(' ', @morse_code);
print @spaceIndex

DECLARE @block VARCHAR(7);
SET @block = SUBSTRING(@morse_code, 1, @spaceIndex - 1);
print @block

SET @morse_code = LTRIM(SUBSTRING(@morse_code, @spaceIndex, LEN(@morse_code) - @spaceIndex + 1));
print @morse_code













-- morse code                    = '-- --- .-. ... . / -.-. --- -.. .'
DECLARE @morse_code VARCHAR(MAX) = '-- --- .-. ... . / -.-. --- -.. .'
DECLARE @translated_text VARCHAR(MAX);

SET @translated_text = dbo.sfn_morse_code_to_text(@morse_code);

PRINT @translated_text;













-- 1965 software nuggets         = '.---- ----. -.... ..... / ... --- ..-. - .-- .- .-. . / -. ..- --. --. . - ...'
DECLARE @morse_code VARCHAR(MAX) = '.---- ----. -.... ..... / ... --- ..-. - .-- .- .-. . / -. ..- --. --. . - ...'
DECLARE @translated_text VARCHAR(MAX);

SET @translated_text = dbo.sfn_morse_code_to_text(@morse_code);

PRINT @translated_text;













--5 + 8 = 13                     = '..... / .-.-. / ---.. / -...- / .---- ...--'
DECLARE @morse_code VARCHAR(MAX) = '..... / .-.-. / ---.. / -...- / .---- ...--'
DECLARE @translated_text VARCHAR(MAX);

SET @translated_text = dbo.sfn_morse_code_to_text(@morse_code);

PRINT @translated_text;
