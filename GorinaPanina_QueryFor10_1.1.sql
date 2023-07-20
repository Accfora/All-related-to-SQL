declare @number int = 1000234905
declare @result int = 0
declare @power int = 0

declare @right int = 0
declare @main int = @number % 10
set @number /= 10
declare @left int = @number % 10
set @number /= 10

while @number <> 0 or @main <> 0 or @left <> 0
begin
	if @right + @main + @left <= 15 
	begin
		set @result += @main * POWER(10,@power)
		set @power += 1
	end

	set @right = @main
	set @main = @left
	set @left = @number % 10
	set @number /= 10
end

print @result