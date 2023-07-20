declare @string varchar(100) = ' '+'алушта алупка залупка алфавит сашечка пиздец ааа'+' '
declare @continue_sort bit = 1

while @continue_sort = 1
begin
	set @continue_sort = 0
	declare @leftspace int = 0
	declare @middlespace int = 0
	declare @rightspace int = 0
	while CHARINDEX(' ',SUBSTRING(@string,@rightspace+1,len(@string))) <> 0
	begin
		set @leftspace += CHARINDEX(' ',SUBSTRING(@string,@leftspace+1,len(@string)))
		set @middlespace = @leftspace + CHARINDEX(' ',SUBSTRING(@string,@leftspace+1,len(@string)))
		set @rightspace = @middlespace + CHARINDEX(' ',SUBSTRING(@string,@middlespace+1,len(@string)))

		if SUBSTRING(@string,@middlespace+1,@rightspace-@middlespace-1) < SUBSTRING(@string,@leftspace+1,@middlespace-@leftspace-1) 
		begin
			set @string = SUBSTRING(@string,1,@leftspace-1) + ' ' 
						+ SUBSTRING(@string,@middlespace+1,@rightspace-@middlespace-1) + ' '
						+ SUBSTRING(@string,@leftspace+1,@middlespace-@leftspace-1) + ' '
						+ SUBSTRING(@string,@rightspace+1,len(@string))
			set @middlespace += @rightspace - 2 * @middlespace + @leftspace
			set @continue_sort = 1
		end
	end
end

print substring(@string,2,len(@string))