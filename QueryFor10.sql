--- 1.1

Declare @x int = 351123
Declare @tempx int = @x
Declare @xed int = 0
Declare @result int = 0

--declare @co int = 0

While @tempx<>0 
begin
	set @xed *= 10
	set @xed += @tempx % 10
	set @tempx = @tempx/10 
	--set @co += 1
End

--set @co /=2

--While @co<>0
While @x <> 0
begin
	set @result *= 10
	set @result += (@xed % 10) / (@x % 10)
	set @x /= 10 
	set @xed /= 10
	--set @co -=1
End

print @result

--- 1.2

Declare @x2 int = 351123
Declare @result2 int = 0
Declare @s varchar(100) = cast(@x2 as varchar(100))
Declare @i int = 1

while @i<>len(@s)+1 
--and @i < len(@s)+1 - @i
begin
	set @result2 *= 10
	set @result2 += cast(SUBSTRING(@s,@i,1) as int) / cast(SUBSTRING(@s,len(@s)-@i+1,1) as int)
	print @i
	set @i += 1
End

print @result2

--- 1.3

Declare @x3 int = 351123
Declare @t table (id int identity (1,1), digit int)

While @x3<>0 
begin
	insert into @t values (@x3 % 10)
	Set @x3 = @x3/10 
End

select cast(string_agg(t_copy.digit/t.digit,'') as int) as res 
from @t as t inner join @t as t_copy on t.id = (select count(*)+1 from @t) - t_copy.id
--where t.id <= (select max(id) from (select id from @t) e)/2

--- 2.1

Declare @st varchar(100) = '  Стррокаа    дляя тестирования' + ' '
Declare @iter int = 1
Declare @output varchar(100) = ''
Declare @temp varchar(100)

while CHARINDEX(' ',@st) <> 0
begin
	set @temp = substring(@st,1,CHARINDEX(' ',@st))
	set @iter = 1

	While @iter<=len(@temp)
	begin
		if (select len(@temp) - len(replace(@temp, substring (@temp,@iter,1), ''))) = 1 set @output += substring (@temp,@iter,1) 
		Set @iter += 1 
	end

	set @st = SUBSTRING(@st,@iter+1,len(@st))
	set @output += ' '
end
print @output

--- 2.2

--drop function func;

--CREATE FUNCTION func (@w varchar(100))
--RETURNS nvarchar(100)
--as
--begin
--declare @tt table (letter varchar(1))
--declare @i int = 1

--While @i<=len(@w)
--begin
--	insert into @tt values (substring(@w,@i,1))
--	set @i += 1
--End
--return 
--(select string_agg(sdthbs.l,'') 
--from (select letter as l from @tt as tt where (select count(*) from @tt where letter like tt.letter) = 1) as sdthbs)
--end

Declare @st2 varchar(100) = 'Стррокаа дляя тестирования'
Declare @t2 table (id int identity (1,1), word varchar(100))
Declare @output2 varchar(100) = ''
Declare @iter2 int
Declare @temp2 varchar(100)

Insert @t2 (word)
Select value from string_split (@st2,' ')

select string_agg(dbo.func(word),' ') from @t2