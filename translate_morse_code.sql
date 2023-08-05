--GitHub
--https://github.com/softwareNuggets
--       /SQL_Server_examples
--       /translate_morse_code.sql
--
--drop function sfn_translate_morse_code


CREATE FUNCTION sfn_translate_morse_code (@morse_code VARCHAR(MAX))
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

			-- Find the position of the next space or the end of the Morse code sequence.
			-- The space separates Morse code segments (words).
			DECLARE @spaceIndex INT = CHARINDEX(' ', @morse_code);
			IF @spaceIndex = 0
				SET @spaceIndex = LEN(@morse_code) + 1;

			-- Get the next Morse code segment (word).
			SET @block = SUBSTRING(@morse_code, 1, @spaceIndex - 1);

			-- Remove the processed segment from the morse code
			SET @morse_code = LTRIM(SUBSTRING(@morse_code, @spaceIndex, LEN(@morse_code) - @spaceIndex + 1));

			-- Now, we look up the character (letter or number) that corresponds to the Morse code segment.
			-- If found, we add it to the translation; otherwise, we add a space.
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








-- touch            = '- --- ..- -.-. ....'
DECLARE @morse_code VARCHAR(MAX) = '-- --- .-. ... . / -.-. --- -.. .'
DECLARE @translated_text VARCHAR(MAX);

SET @translated_text = dbo.sfn_translate_morse_code(@morse_code);

PRINT @translated_text;


-- 1965 software nuggets = '.---- ----. -.... ..... / ... --- ..-. - .-- .- .-. . / -. ..- --. --. . - ...'
DECLARE @morse_code VARCHAR(MAX) = '.---- ----. -.... ..... / ... --- ..-. - .-- .- .-. . / -. ..- --. --. . - ...'
DECLARE @translated_text VARCHAR(MAX);

SET @translated_text = dbo.sfn_translate_morse_code(@morse_code);

PRINT @translated_text;


--5 + 8 = 13     '..... / .-.-. / ---.. / -...- / .---- ...--'
DECLARE @morse_code VARCHAR(MAX) = '..... / .-.-. / ---.. / -...- / .---- ...--'
DECLARE @translated_text VARCHAR(MAX);

SET @translated_text = dbo.sfn_translate_morse_code(@morse_code);

PRINT @translated_text;
