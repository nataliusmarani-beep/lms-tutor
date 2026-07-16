-- ============================================================
-- excel-clips-resources.sql — 60 Excel clips as ENGLISH video resources
-- Idempotent: re-running refreshes only THIS language's clip videos.
-- Run in the Supabase SQL Editor.  Host course default:
-- "Microsoft Digital Skills for University Prep" > module "Excel Clips".
-- ============================================================

DO $$
DECLARE
  v_course_id UUID;
  v_mod_id    UUID;
BEGIN
  SELECT id INTO v_course_id FROM courses
   WHERE title = 'Microsoft Digital Skills for University Prep' LIMIT 1;
  IF v_course_id IS NULL THEN
    RAISE NOTICE 'Host course not found — nothing seeded.'; RETURN;
  END IF;

  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND title = 'Excel Clips' LIMIT 1;
  IF v_mod_id IS NULL THEN
    v_mod_id := gen_random_uuid();
    INSERT INTO course_modules
      (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
    VALUES
      (v_mod_id, v_course_id, 'Excel Clips', 'Klip Excel',
       '60 short Excel tutorial clips to watch and practice',
       '60 klip tutorial Excel singkat untuk ditonton dan dipraktikkan',
       '📊',
       (SELECT COALESCE(MAX(week_number), 0) + 1 FROM course_modules WHERE course_id = v_course_id),
       (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM course_modules WHERE course_id = v_course_id));
  END IF;

  -- Refresh only this language's clip videos (scoped by title marker)
  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id
     AND resource_type = 'video'
     AND title LIKE 'W_% · %';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order)
  VALUES
    (v_mod_id, 'video', 'W1 · Excel interface tour (ribbon, cells, name box, formula bar)', 'https://www.youtube.com/watch?v=SOvI2_dL02Q', 'Open a blank workbook and point out the ribbon, a cell, the Name Box, and the formula bar. Type your name in cell A1.', 1),
    (v_mod_id, 'video', 'W1 · Entering and editing data (Enter, Tab, F2)', 'https://www.youtube.com/watch?v=MFSvwFUirEM', 'Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', 3),
    (v_mod_id, 'video', 'W1 · Selecting cells, rows, columns, and ranges', 'https://www.youtube.com/watch?v=_tnbn96yxIc', 'Select column A, then row 1, then the range A1:C5 by clicking and dragging.', 5),
    (v_mod_id, 'video', 'W1 · Copy, cut, paste, and Paste Special (values only)', 'https://www.youtube.com/watch?v=Y5CKUd-Q3i4', 'Copy A1:A5, then use Paste Special -> Values to paste only the values into C1.', 7),
    (v_mod_id, 'video', 'W1 · AutoFill and Flash Fill', 'https://www.youtube.com/watch?v=jOeiKZz7Y5Q', 'Type 1 and 2 and drag the fill handle to make 1-10, then use Flash Fill to split first names from a full-name column.', 9),
    (v_mod_id, 'video', 'W1 · Undo/Redo and saving (.xlsx vs .csv)', 'https://www.youtube.com/watch?v=O1Z7WjdyHbY', 'Delete a row, press Ctrl+Z to undo, then save the file once as .xlsx and once as .csv.', 11),
    (v_mod_id, 'video', 'W1 · Freeze Panes', 'https://www.youtube.com/watch?v=wjGzYpdIcxY', 'Add a header row, then use View -> Freeze Panes -> Freeze Top Row and scroll to test it.', 13),
    (v_mod_id, 'video', 'W1 · Inserting/deleting rows and columns, resizing', 'https://www.youtube.com/watch?v=_JjqaMmDlig', 'Insert a new row above row 2, delete column B, and widen column A.', 15),
    (v_mod_id, 'video', 'W1 · Working with multiple sheets', 'https://www.youtube.com/watch?v=qRShQc-v3LI', 'Rename Sheet1 to ''Stock'', add a second sheet named ''Prices'', and give the tabs different colors.', 17),
    (v_mod_id, 'video', 'W2 · Number formats (currency Rp, percentage, dates)', 'https://www.youtube.com/watch?v=sKv2DOwk6-A', 'Format one column as Currency (Rp), one as Percentage, and one as Date.', 19),
    (v_mod_id, 'video', 'W2 · Cell formatting (bold, borders, fill, wrap text)', 'https://www.youtube.com/watch?v=ryrz6UVvOwM', 'Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', 21),
    (v_mod_id, 'video', 'W2 · Merge & Center vs Center Across Selection', 'https://www.youtube.com/watch?v=2PkEfxayYrs', 'Use Merge & Center on a title across A1:C1, then redo it with Center Across Selection instead.', 23),
    (v_mod_id, 'video', 'W2 · Format Painter', 'https://www.youtube.com/watch?v=pKQf06bLs28', 'Format one cell nicely, then use Format Painter to copy that look onto 5 other cells.', 25),
    (v_mod_id, 'video', 'W2 · Conditional Formatting (highlight low stock)', 'https://www.youtube.com/watch?v=DXbUjlR9URA', 'Add a Highlight Cells rule so any stock value below 10 turns red.', 27),
    (v_mod_id, 'video', 'W2 · Format as Table', 'https://www.youtube.com/watch?v=M07df44RXOM', 'Select your data and apply Format as Table, then try the filter arrows in the header.', 29),
    (v_mod_id, 'video', 'W2 · Cell styles and themes', 'https://www.youtube.com/watch?v=Stnq9DNwGME', 'Apply a built-in Cell Style to your header, then change the workbook Theme.', 31),
    (v_mod_id, 'video', 'W3 · Your first formula (=, cell references, + − * /)', 'https://www.youtube.com/watch?v=S3fhooS5Oik', 'In C2 type =A2+B2, then try the same with - , * and / on your own numbers.', 33),
    (v_mod_id, 'video', 'W3 · SUM and AutoSum', 'https://www.youtube.com/watch?v=oSa7pP5um_s', 'Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', 35),
    (v_mod_id, 'video', 'W3 · AVERAGE, MIN, MAX', 'https://www.youtube.com/watch?v=k3MHxObhD_0', 'Add AVERAGE, MIN, and MAX below a column of prices.', 37),
    (v_mod_id, 'video', 'W3 · COUNT vs COUNTA vs COUNTBLANK', 'https://www.youtube.com/watch?v=K7qO3PBCCgM', 'Use COUNT, COUNTA, and COUNTBLANK on a column that has some blank cells.', 39),
    (v_mod_id, 'video', 'W3 · Relative vs absolute references ($A$1)', 'https://www.youtube.com/watch?v=DIkBBIo0thw', 'Write a formula using $A$1 and copy it down to see the reference stay fixed.', 41),
    (v_mod_id, 'video', 'W3 · Copying formulas down a column', 'https://www.youtube.com/watch?v=PVhuI4pJ6es', 'Write one formula in D2, then double-click the fill handle to copy it down the whole column.', 43),
    (v_mod_id, 'video', 'W4 · IF (pass/fail decisions)', 'https://www.youtube.com/watch?v=jIYD7wiWDU4', 'Write =IF(A2>=60,"Pass","Fail") for a list of scores.', 45),
    (v_mod_id, 'video', 'W4 · Nested IF and IFS (grading A/B/C/D)', 'https://www.youtube.com/watch?v=5vzcDWuB6Ys', 'Grade a list of scores into A/B/C/D using IFS (or nested IF).', 47),
    (v_mod_id, 'video', 'W4 · AND / OR inside IF', 'https://www.youtube.com/watch?v=5vHT16cEOPc', 'Write an IF that passes only when score>=60 AND attendance>=80 using AND().', 49),
    (v_mod_id, 'video', 'W4 · COUNTIF / COUNTIFS', 'https://www.youtube.com/watch?v=ut4hez1MJ3s', 'Count how many items are ''Low'' with COUNTIF, then add a second condition using COUNTIFS.', 51),
    (v_mod_id, 'video', 'W4 · SUMIF / SUMIFS', 'https://www.youtube.com/watch?v=dI8w0utjUc0', 'Total the quantity for one category with SUMIF, then use two conditions with SUMIFS.', 53),
    (v_mod_id, 'video', 'W4 · AVERAGEIF', 'https://www.youtube.com/watch?v=bCX-qAz2Cqk', 'Find the average price of items in one category using AVERAGEIF.', 55),
    (v_mod_id, 'video', 'W5 · VLOOKUP (find a price from a master list)', 'https://www.youtube.com/watch?v=xIynD1gFOLo', 'Build a small price list and use VLOOKUP to pull a price by item code.', 57),
    (v_mod_id, 'video', 'W5 · XLOOKUP (the modern replacement)', 'https://www.youtube.com/watch?v=y5H6Yi3V4cw', 'Redo the same lookup with XLOOKUP.', 59),
    (v_mod_id, 'video', 'W5 · INDEX + MATCH', 'https://www.youtube.com/watch?v=6JhbY8Mku1A', 'Look up a value using INDEX and MATCH together.', 61),
    (v_mod_id, 'video', 'W5 · IFERROR (clean up #N/A)', 'https://www.youtube.com/watch?v=xEjLwqYjKFk', 'Wrap your lookup in IFERROR so #N/A shows "Not found" instead.', 63),
    (v_mod_id, 'video', 'W6 · CONCAT / TEXTJOIN and & (combine names)', 'https://www.youtube.com/watch?v=77NAWZwi0CI', 'Combine first and last name into one cell using & , then again using TEXTJOIN.', 65),
    (v_mod_id, 'video', 'W6 · LEFT, RIGHT, MID (extract codes)', 'https://www.youtube.com/watch?v=PbWRI7ANjsE', 'Extract the first 3 letters of a code with LEFT and the middle part with MID.', 67),
    (v_mod_id, 'video', 'W6 · UPPER, LOWER, PROPER', 'https://www.youtube.com/watch?v=PkuhtMDkGUI', 'Convert a name column to UPPER, LOWER, and PROPER case.', 69),
    (v_mod_id, 'video', 'W6 · TRIM and CLEAN', 'https://www.youtube.com/watch?v=6xD59AgxUi8', 'Use TRIM to remove extra spaces from a messy text column.', 71),
    (v_mod_id, 'video', 'W6 · TEXT function (format inside text)', 'https://www.youtube.com/watch?v=lpux4m0jsdk', 'Use TEXT to show a number as "Rp #,##0" inside a sentence.', 73),
    (v_mod_id, 'video', 'W6 · TODAY and NOW', 'https://www.youtube.com/watch?v=HUstL5T5L4s', 'Put =TODAY() in one cell and =NOW() in another.', 75),
    (v_mod_id, 'video', 'W6 · DATEDIF and date math', 'https://www.youtube.com/watch?v=uXItl_HQR5Q', 'Use DATEDIF to find the number of days between two dates.', 77),
    (v_mod_id, 'video', 'W6 · WEEKDAY, MONTH, YEAR', 'https://www.youtube.com/watch?v=ajCHNzO774w', 'Pull the weekday, month, and year out of a date using WEEKDAY, MONTH, and YEAR.', 79),
    (v_mod_id, 'video', 'W7 · Sort (A-Z, multi-level)', 'https://www.youtube.com/watch?v=YkaYOSduu40', 'Sort your table by category, then add a second level to also sort by quantity.', 81),
    (v_mod_id, 'video', 'W7 · Filter', 'https://www.youtube.com/watch?v=4i1DH6EwIIE', 'Turn on Filter and show only the items in one category.', 83),
    (v_mod_id, 'video', 'W7 · Remove Duplicates', 'https://www.youtube.com/watch?v=7hJstN44pTE', 'Add a duplicate row, then use Remove Duplicates to clean it up.', 85),
    (v_mod_id, 'video', 'W7 · Data Validation (dropdown lists)', 'https://www.youtube.com/watch?v=uQd92e6ilBQ', 'Add a dropdown list of categories to a column using Data Validation.', 87),
    (v_mod_id, 'video', 'W7 · Text to Columns', 'https://www.youtube.com/watch?v=QyZ6IMkln2U', 'Split a ''Name Code'' column into two columns using Text to Columns.', 89),
    (v_mod_id, 'video', 'W7 · Find & Replace', 'https://www.youtube.com/watch?v=4hiVLC7vgf0', 'Use Find & Replace to change every ''pcs'' to ''units''.', 91),
    (v_mod_id, 'video', 'W7 · Grouping and outlining', 'https://www.youtube.com/watch?v=0S2ZHyxd2NI', 'Group a set of rows so you can collapse and expand them.', 93),
    (v_mod_id, 'video', 'W8 · Creating your first chart', 'https://www.youtube.com/watch?v=64DSXejsYbo', 'Select a small table and insert a column chart.', 95),
    (v_mod_id, 'video', 'W8 · Choosing the right chart type', 'https://www.youtube.com/watch?v=IHffvF4Vrm8', 'Show the same data as a bar, line, and pie chart, then pick the clearest one.', 97),
    (v_mod_id, 'video', 'W8 · Formatting charts', 'https://www.youtube.com/watch?v=ZeZ94yEa6xI', 'Add a chart title and data labels, then change the chart colors.', 99),
    (v_mod_id, 'video', 'W8 · Sparklines', 'https://www.youtube.com/watch?v=xCDcrC0a6Zo', 'Add a line sparkline next to each row of monthly numbers.', 101),
    (v_mod_id, 'video', 'W8 · PivotTables part 1 (summarize data)', 'https://www.youtube.com/watch?v=dvbLrwD2SpA', 'Create a PivotTable that sums quantity by category.', 103),
    (v_mod_id, 'video', 'W8 · PivotTables part 2 (grouping, slicers)', 'https://www.youtube.com/watch?v=mW4QWFW1oO8', 'Group your PivotTable and add a Slicer to filter it.', 105),
    (v_mod_id, 'video', 'W8 · PivotCharts', 'https://www.youtube.com/watch?v=7IbW_DF89Ws', 'Add a PivotChart to your PivotTable.', 107),
    (v_mod_id, 'video', 'W9 · Top 10 keyboard shortcuts', 'https://www.youtube.com/watch?v=2edm5xqn-8I', 'Practice Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S and a few more shortcuts on your workbook.', 109),
    (v_mod_id, 'video', 'W9 · Print setup (print area, fit to page)', 'https://www.youtube.com/watch?v=Mrt4v0ysA8w', 'Set a Print Area, then use ''Fit to 1 page wide'' in Print settings.', 111),
    (v_mod_id, 'video', 'W9 · Page headers/footers and page numbers', 'https://www.youtube.com/watch?v=1uFzJfiP-ZI', 'Add a header with the sheet title and a footer with page numbers.', 113),
    (v_mod_id, 'video', 'W9 · Protecting sheets and locking cells', 'https://www.youtube.com/watch?v=wrOE8fheMR0', 'Lock your formula cells and protect the sheet, leaving the input cells editable.', 115),
    (v_mod_id, 'video', 'W9 · Comments and notes', 'https://www.youtube.com/watch?v=aY-p0oySZa0', 'Add a comment to one cell and a note to another.', 117),
    (v_mod_id, 'video', 'W9 · Exporting to PDF and sharing', 'https://www.youtube.com/watch?v=iuoQyIZW0tA', 'Save or export your finished workbook as a PDF.', 119);

END $$;
