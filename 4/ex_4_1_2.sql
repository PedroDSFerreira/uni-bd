CREATE TABLE flight (
	[number] [int] NOT NULL PRIMARY KEY,
	[airline] [varchar](64) NOT NULL,
	[weekdays] [varchar](32) NOT NULL
);

CREATE TABLE fare(
	[code] [int] NOT NULL PRIMARY KEY,
	[restrictions] [varchar](256) NOT NULL,
	[amount] [int] NOT NULL,
	[f_number] [int] NOT NULL REFERENCES flight([number])
);

CREATE TABLE airplane_type(
	[type_name] [varchar](16) NOT NULL PRIMARY KEY,
	[max_seats] [int] NOT NULL,
	[company] [varchar](32) NOT NULL
);

CREATE TABLE airplane(
	[airplane_id] [varchar](16) NOT NULL PRIMARY KEY,
	[total_no_of_seats] [int] NOT NULL,
	[a_type_name] [varchar](16) NOT NULL UNIQUE REFERENCES airplane_type([type_name])
);

CREATE TABLE airport(
	[airport_code] [varchar](8) NOT NULL PRIMARY KEY,
	[city] [varchar](16) NOT NULL,
	[state] [varchar](32) NOT NULL,
	[name] [varchar](64) NOT NULL
);

CREATE TABLE flight_leg(
	[leg_no] [int] NOT NULL PRIMARY KEY,
	[schedule_dep_time] [time] NOT NULL,
	[schedule_arr_time] [time] NOT NULL,
	[f_number] [int] NOT NULL UNIQUE REFERENCES flight([number]),
	[a_code_1] [int] NOT NULL UNIQUE REFERENCES fare([code]),
	[a_code_2] [int] NOT NULL UNIQUE REFERENCES fare([code])
);

CREATE TABLE leg_instance(
	[date] [date] NOT NULL PRIMARY KEY,
	[no_of_avail_seats] [int] NOT NULL,
	[a_code_1] [int] NOT NULL UNIQUE REFERENCES flight_leg([a_code_1]),
	[a_code_2] [int] NOT NULL UNIQUE REFERENCES flight_leg([a_code_2]),
	[f_number] [int] NOT NULL UNIQUE REFERENCES flight_leg([f_number]),
	[f_leg_no] [int] NOT NULL UNIQUE REFERENCES flight_leg([leg_no]),
	[a_id] [varchar](16) NOT NULL UNIQUE REFERENCES airplane([airplane_id])
);

CREATE TABLE seat(
	[seat_no] [int] NOT NULL PRIMARY KEY,
	[customer_name] [varchar](256) NOT NULL,
	[a_code_1] [int] NOT NULL REFERENCES leg_instance([a_code_1]),
	[a_code_2] [int] NOT NULL REFERENCES leg_instance([a_code_2]),
	[f_number] [int] NOT NULL REFERENCES leg_instance([f_number]),
	[f_leg_no] [int] NOT NULL REFERENCES leg_instance([f_leg_no]),
	[a_id] [varchar](16) NOT NULL REFERENCES leg_instance([a_id]),
	[leg_i_date] [date] NOT NULL REFERENCES leg_instance([date])
);

CREATE TABLE can_land(
	[airport_code] [varchar](8) NOT NULL FOREIGN KEY REFERENCES airport([airport_code]),
	[type_name] [varchar](16) NOT NULL FOREIGN KEY REFERENCES airplane([a_type_name])
);