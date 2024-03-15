program ej1;
uses crt;

const
    FIN = 3000;

type
    archivo_numeros = file of integer;

var 
    a1: archivo_numeros;
    nombre_fisico: string;
    num: integer;

begin

    write('Ingrese el nombre que le quiere asignar al archivo: ');
    readln(nombre_fisico); 
    assign(a1, nombre_fisico); //relacionamos el nombre lógico con el nombre fisico
    rewrite(a1); //creamos el archivo

    write('Ingrese un numero a incorporar al archivo (con ',FIN,' finaliza): ');
    read(num);
    while(num <> FIN) do begin
        write(a1, num); //num es aceptado por ser del tipo integer, ya que es lo que almacena el archivo
        write('Ingrese otro numero: ');
        readln(num);
    end;

    close(a1); //no olvidar
end.