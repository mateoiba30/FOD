program prueba;

procedure cambio(var bool: boolean); //el var hace que el parámetro sea un puntero, para poder cambiar los valores
begin
    bool:=true;
end;
var 
    numero: integer;
    bool: boolean;
begin
    bool:=false;
    cambio(bool);
    write(bool);

end.