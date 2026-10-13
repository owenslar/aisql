-- addresses (1-4 schools, 5-9 courses)
insert into address (address_id, city, state, street, zip) values
    (1, 'Provo', 'UT', '1450 N University Ave', '84604'),
    (2, 'Highland', 'UT', '11800 N 5300 W', '84003'),
    (3, 'Orem', 'UT', '175 S 400 E', '84097'),
    (4, 'Nephi', 'UT', '555 E 800 N', '84648'),
    (5, 'Provo', 'UT', '2701 N University Ave', '84604'),
    (6, 'Lehi', 'UT', '3003 N Thanksgiving Way', '84043'),
    (7, 'Orem', 'UT', '1200 W 1600 N', '84057'),
    (8, 'Hurricane', 'UT', '5662 W Clubhouse Dr', '84737'),
    (9, 'Springville', 'UT', '5984 E Hobble Creek Canyon Rd', '84663');

insert into school (school_id, name, division, address_id) values
    (1, 'Timpview High School', '5A', 1),
    (2, 'Lone Peak High School', '6A', 2),
    (3, 'Orem High School', '5A', 3),
    (4, 'Juab High School', '3A', 4);

insert into team (team_id, team_name, school_id) values
    (1, 'Timpview Varsity', 1),
    (2, 'Timpview JV', 1),
    (3, 'Lone Peak Varsity', 2),
    (4, 'Orem Varsity', 3),
    (5, 'Juab Varsity', 4);

insert into player (player_id, first_name, middle_name, last_name, graduation_date) values
    (1, 'Jake', 'Ryan', 'Anderson', '2025-05-30'),
    (2, 'Ethan', 'Cole', 'Barlow', '2026-05-30'),
    (3, 'Tyler', null, 'Christensen', '2025-05-30'),
    (4, 'Spencer', 'James', 'Dalton', '2027-05-30'),
    (5, 'Caleb', null, 'Ellsworth', '2028-05-30'),
    (6, 'Mason', 'Lee', 'Fowler', '2026-05-30'),
    (7, 'Brigham', 'Thomas', 'Hale', '2025-05-30'),
    (8, 'Luke', null, 'Jensen', '2026-05-30'),
    (9, 'Carter', 'Wade', 'Kimball', '2027-05-30'),
    (10, 'Dallin', 'Paul', 'Larsen', '2025-05-30'),
    (11, 'Ty', null, 'Madsen', '2026-05-30'),
    (12, 'Bryce', 'Allen', 'Nielsen', '2027-05-30'),
    (13, 'Colton', 'Ray', 'Ostler', '2025-05-30'),
    (14, 'Hunter', null, 'Pratt', '2026-05-30'),
    (15, 'Kade', 'Michael', 'Quinn', '2028-05-30'),
    (16, 'Noah', null, 'Reeves', '2027-05-30');

insert into course (course_id, name, par, yardage, address_id, course_rating, slope_rating) values
    (1, 'Riverside Country Club', 72, 6800, 5, 72.4, 131),
    (2, 'Thanksgiving Point Golf Club', 72, 7200, 6, 74.1, 139),
    (3, 'Sleepy Ridge Golf Course', 71, 6600, 7, 70.8, 125),
    (4, 'Sand Hollow Resort', 72, 7300, 8, 74.8, 144),
    (5, 'Hobble Creek Golf Course', 71, 6300, 9, 69.5, 120);

insert into tournament (tournament_id, name, date, course_id) values
    (1, 'Timpanogos Invitational', '2025-03-20', 1),
    (2, 'Thanksgiving Point Classic', '2025-04-03', 2),
    (3, 'Sleepy Ridge Shootout', '2025-04-17', 3),
    (4, 'Utah State Championship', '2025-05-12', 4);

insert into team_tournament (team_id, tournament_id) values
    (1, 1), (2, 1), (3, 1), (4, 1),
    (1, 2), (3, 2), (4, 2), (5, 2),
    (1, 3), (2, 3), (4, 3), (5, 3),
    (1, 4), (3, 4), (4, 4);

-- a null back_nine_score means the player withdrew after the front nine
-- Mason Fowler (6) played JV in the first tournament, then moved up to varsity
insert into player_tournament (player_id, tournament_id, front_nine_score, back_nine_score, team_id) values
    -- Timpanogos Invitational
    (1, 1, 37, 38, 1),
    (2, 1, 39, 41, 1),
    (3, 1, 40, 42, 1),
    (4, 1, 45, 47, 2),
    (5, 1, 48, 50, 2),
    (6, 1, 44, 46, 2),
    (7, 1, 36, 37, 3),
    (8, 1, 38, 40, 3),
    (9, 1, 41, 43, 3),
    (10, 1, 38, 39, 4),
    (11, 1, 42, null, 4),
    (12, 1, 43, 44, 4),
    -- Thanksgiving Point Classic
    (1, 2, 38, 40, 1),
    (2, 2, 37, 39, 1),
    (3, 2, 41, 43, 1),
    (6, 2, 42, 43, 1),
    (7, 2, 37, 39, 3),
    (8, 2, 36, 38, 3),
    (9, 2, 40, 42, 3),
    (10, 2, 39, 41, 4),
    (11, 2, 40, 41, 4),
    (12, 2, 44, 45, 4),
    (13, 2, 41, 42, 5),
    (14, 2, 45, null, 5),
    (15, 2, 46, 48, 5),
    -- Sleepy Ridge Shootout
    (1, 3, 35, 36, 1),
    (2, 3, 38, 37, 1),
    (3, 3, 39, 40, 1),
    (6, 3, 40, 41, 1),
    (4, 3, 43, 44, 2),
    (5, 3, 46, 45, 2),
    (10, 3, 36, 38, 4),
    (11, 3, 39, 40, 4),
    (12, 3, 41, 42, 4),
    (13, 3, 38, 39, 5),
    (14, 3, 42, 43, 5),
    (15, 3, 44, 47, 5),
    -- Utah State Championship
    (1, 4, 37, 37, 1),
    (2, 4, 39, 40, 1),
    (3, 4, 41, 42, 1),
    (6, 4, 42, 44, 1),
    (7, 4, 36, 37, 3),
    (8, 4, 38, 39, 3),
    (9, 4, 40, 41, 3),
    (10, 4, 37, 39, 4),
    (11, 4, 40, 42, 4),
    (12, 4, 43, 43, 4);
