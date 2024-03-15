program ej2;
uses crt;

const
    MIN=1500;

type
    archivo_numeros = file of integer;

var
    a1: archivo_numeros;
    num, cant_numeros, cant_menores, suma: integer;
    promedio: real;
    nombre_fisico: string;

begin
    cant_numeros:=0;
    cant_menores:=0;
    suma:=0;

    write('Ingrese el nombre del archivo: '); //no indicar el .tipo del archivo, solo el nombre
    readln(nombre_fisico);
    assign(a1, nombre_fisico); //relacionamos nombre lógico con nombre físico
    reset(a1); //abrimos el archivo existente

    write('Contenido del archivo seleccionado: ');
    //al hacer read, el puntero avanza solo al siguiente elemento
    while not eof(a1) do begin
        read(a1, num);
        write(num,', ');
        if(num<MIN) then 
            cant_menores:=cant_menores+1;
        suma:= suma + num;
        cant_numeros:=cant_numeros+1;
    end;

    writeln('');
    writeln('Cantidad de numeros menores a ',MIN,': ', cant_menores);
    promedio:=suma/cant_numeros;
    writeln('Promedio de numeros menores a ',MIN,': ', promedio:0:2);
end.