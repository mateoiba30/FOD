program ej7;

const
    FIN=-99;

type
    novela=record
        codigo: integer;
        nombre, genero: string;
        precio: real;
    end;

    archivo_novelas = file of novela;

procedure crearBinario(var a1: archivo_novelas; var txt: Text);
var
    nov: novela;

begin
    reset(txt);
    rewrite(a1); //creamos al archivo

    while(not eof(txt)) do begin
        readln(txt, nov.codigo, nov.precio, nov.genero);
        readln(txt, nov.nombre);
        write(a1, nov);
    end;
    close(a1);
    close(txt);
end;

procedure mostrarNovelas(var a1: archivo_novelas);
var
    nov:novela;

begin
    reset(a1);//lo abrimos en el incio del archivo

    writeln('Novelas: ');
    while(not eof(a1)) do begin
        read(a1, nov);
        writeln('codigo: ', nov.codigo, ', precio: ', nov.precio:0:2, ', genero: ', nov.genero,', nombre: ', nov.nombre);
    end;

    close(a1);
end;

function novelaRegistrada(nombre: string; var a1: archivo_novelas; pos: integer): boolean;
var
    encontre: boolean;
    nov: novela;

begin
    seek(a1, 0); //buscamos desde el inicio
    encontre:=false;
    while(not eof(a1)) and (encontre=false) do begin
        read(a1, nov);
        if( nov.nombre = nombre ) then
            encontre := true;
    end;
    seek(a1, pos); //volvemos a la posicion original
    novelaRegistrada:=encontre;
end;

procedure agregarNovela(var a1: archivo_novelas);
var
    nov:novela;
    contador: integer;

begin
    contador:=1;
    reset(a1); //abrimos el archivo existente
    seek(a1, fileSize(a1));//nos paramos al final para agregar informacion

    write('Ingrese codigo de la novela 1 (ingrese ',FIN,' para terminar): ');
    readln(nov.codigo);
   
    while (nov.codigo<>FIN) do begin
        write('Ingrese el precio: ');
        readln(nov.precio);
        write('Ingrese el genero: ');
        readln(nov.genero);
        write('Ingrese el nombre: ');
        readln(nov.nombre);

        if(not novelaRegistrada(nov.nombre, a1, filePos(a1))) then begin
            write(a1,nov);
        end
        else begin
            writeln('novela repetida!');
        end;

        contador:=contador+1;
        writeln('');
        write('Ingrese codigo de la novela ',contador,': ');
        readln(nov.codigo);
    end;

    close(a1);
end;

procedure modificarNovela(var a1: archivo_novelas);
var
    codigo: integer;
    nov:novela;
    encontre: boolean;

begin
    encontre:=false;
    reset(a1); //abro el archivo al inicio

    write('Ingrese el codigo de la novela a modificar: ');
    readln(codigo);

    while(not eof(a1)) and (not encontre) do begin
        read(a1, nov);
        if(nov.codigo=codigo) then begin
            encontre:=true;

            write('Ingrese el nuevo precio: ');
            readln(nov.precio);
            write('Ingrese el nuevo genero: ');
            readln(nov.genero);
            write('Ingrese el nuevo nombre: ');
            readln(nov.nombre);

            seek(a1, filePos(a1)-1); //retrocedemos para modificar el celular
            write(a1, nov);//modificamos el archivo
        end
    end;

    if(not encontre) then
        writeln('Novela no encontrada =(');
    
    close(a1);
end;

var
    txt: Text;
    nombre: string;
    a1: archivo_novelas;

begin
    write('Ingrese el nombre del archivo binario a crear: ');
    readln(nombre);
    assign(a1, nombre);
    assign(txt, 'novelas.txt');

    crearBinario(a1, txt);
    mostrarNovelas(a1);

    agregarNovela(a1);
    mostrarNovelas(a1);

    modificarNovela(a1);
    mostrarNovelas(a1);

end.