-- 1.1

declare @number int = 100023495
declare @result int = 0
declare @power int = len(@number) - 1
while @number <> 0
begin
	set @result += (@number % 10) * POWER(10,@power)
	set @number /= 10
	set @power -= 1
end
print @result

-- 1.2

declare @numberr int = 100049500
declare @resultt varchar(100) = ''
declare @s varchar(100) = cast(@numberr as varchar(100))
declare @i int = len(@s)
while @i <> 0
begin
	set @resultt += SUBSTRING(@s,@i,1)
	set @i -= 1
end
print cast(@resultt as int)

-- 1.3

Declare @numberrr int = 100023950
Declare @t table (id int identity (1,1), digit int)

While @numberrr<>0 
begin
	insert into @t values (@numberrr % 10)
	Set @numberrr = @numberrr/10 
End

select cast(string_agg(digit,'') as int) w
from (select * from @t order by id offset 0 rows) v

-- 2.1

declare @ss varchar(100) = 'строка для для тестирования тестирования тестирования'+' '
declare @word varchar(100)
declare @resulttt varchar(100) = ''

while @ss <> ''
-- цикл будет идти, пока мы не вырежем все слова, то есть пока строка не станет пустой
begin
	set @word = substring(@ss,1,patindex('% %',@ss)) 
	-- находит первое слово (от начала строки до первого пробела)
	set @ss = stuff(@ss,1,patindex('% %',@ss),'') 
	-- заменяет в исходной строке это первое слово на пустую строку
	if patindex('%' +@word+ '%',@ss) > 0
		begin
			set @ss = REPLACE(@ss,@word,'')
			set @resulttt += @word
		end
	-- если в исходной строке остались такие же слова, как то, которое мы вырезали, 
	-- то заменяем их все на пустую строку, а это слово добавляем в результат, 
	-- потому что оно было повторяющимся
end
print @resulttt

-- 2.2

Declare @sss varchar(100) = 'строка для для тестирования тестирования тестирования'
Declare @ttt table (word varchar(100))
Insert @ttt (word) Select value from string_split (@sss,' ')

select STRING_AGG(word,' ') as ww from (
Select word from @ttt group by word having count(word) > 1
) vv