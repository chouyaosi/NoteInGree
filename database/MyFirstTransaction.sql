begin tran mytran

declare @tran_error int
set @tran_error=0;

begin try 
 delete from mouldreqentry where mouldreqentryid=1213
 select * from mouldreqentry
end try
begin catch
 set @tran_error=@tran_error+1
end catch
if(@tran_error>0)
begin
commit tran mytran
print @tran_error
end
else
begin
rollback tran mytran
print @tran_error
end

 select * from mouldreqentry


