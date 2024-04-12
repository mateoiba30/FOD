program ej3;

uses crt;

const   
    valorAlto = 9999;
    FIN = '@fin';

type
    novela=record
        cod, duracion:integer;
        genero, nombre, director:string;
        precio:double;
    end;

    archivo_novelas = file of novela;

procedure leer(var a1: archivo_novelas; var nov:novela);
begin
    if(not eof(a1))then   
        read(a1, nov)
    else
        nov.cod := valorAlto;
end;

function existeCodigo(var a1: archivo_novelas; cod:integer; pos: integer):boolean;
var
    nov:novela;
    existe:boolean;
begin
    existe := false;
    reset(a1);

    leer(a1, nov);
    while(nov.cod <> valorAlto) do begin
        if(nov.cod = cod) then begin
            existe := true;
            break;
        end;
        leer(a1, nov);
    end;

    existeCodigo := existe;
    seek(a1, pos);
end;

procedure crearArchivo(var a1: archivo_novelas);
var
    nov:novela;

begin
    rewrite(a1);

    nov.cod := 0;
    nov.duracion := 0;
    nov.genero := ' ';
    nov.nombre := ' ';
    nov.director := ' ';
    nov.precio := 0.0;
    //le agrego más información, porque si justo había un número basura donde espero texto entonces la compu piensa que es un archivo binario en lugar de un txt
    write(a1, nov); //ponemos el registro cabecera

    write('Ingrese el nombre de la novela (ingrese "', FIN,'" para terminar): ');
    readln(nov.nombre);
    while(nov.nombre <> FIN) do begin
        write('Ingrese el codigo de la novela: ');
        readln(nov.cod);

        if( existeCodigo(a1, nov.cod, filePos(a1))) then begin
            writeln('El codigo ya existe, pruebe con otro');
            continue;
        end;

        write('Ingrese la duracion de la novela: ');
        readln(nov.duracion);
        write('Ingrese el genero de la novela: ');
        readln(nov.genero);
        write('Ingrese el director de la novela: ');
        readln(nov.director);
        write('Ingrese el precio de la novela: ');
        readln(nov.precio);

        write(a1, nov);
        writeln('');
        write('Ingrese el nombre de otra novela: ');
        readln(nov.nombre);
    end;
    close(a1);
end;

procedure exportarNovelas(var a1: archivo_novelas);
var
    txt: Text;
    nov: novela;

begin
    reset(a1);
    assign(txt, 'novelas.txt');
    rewrite(txt);

    writeln(txt, 'codigo | duracion | genero | nombre | director | precio');
    leer(a1, nov);
    while(nov.cod <> valorAlto) do begin
        writeln(txt, nov.nombre, ' ', nov.duracion, ' ', nov.genero, ' ', nov.nombre, ' ', nov.director, ' ', nov.precio:2:2);
        leer(a1, nov);
    end;

    writeln('Informacion guardada en el archivo ./novelas.txt');
    close(a1);
    close(txt);
end;

procedure agregarNovela(var a1: archivo_novelas);
var
    nov:novela;

begin
    reset(a1);
    seek(a1, fileSize(a1));

    write('Ingrese el nombre de la novela: ');
    readln(nov.nombre);
    write('Ingrese el codigo de la novela: ');
    readln(nov.cod);

    codigoValido := false;
    while(codigoValido = false) do begin
        if( existeCodigo(a1, nov.cod, filePos(a1))) then begin
            writeln('El codigo ya existe, pruebe con otro: ');
            readln(nov.cod);
        end
        else begin
            codigoValido := true;
        end;
    end;

    write('Ingrese la duracion de la novela: ');
    readln(nov.duracion);
    write('Ingrese el genero de la novela: ');
    readln(nov.genero);
    write('Ingrese el director de la novela: ');
    readln(nov.director);
    write('Ingrese el precio de la novela: ');
    readln(nov.precio);

    write(a1, nov);
    writeln('Novela argegada en el primer espacio libre');
end;

var
    a1: archivo_novelas;
    nombre_fisico:string;
    terminar:boolean;
    opcion:integer;

begin
    write('Ingrese el nombre del ARCHIVO BINARIO a manipular: ');
    readln(nombre_fisico);
    assign(a1, nombre_fisico);

    terminar:=false;
    while(terminar=false) do begin
        writeln('Ingrese una de las siguientes opciones:');
        writeln('0: FINALIZAR');
        writeln('1: crear archivo'); //como lista invertida
        writeln('2: agregar novela'); //aprovechando las eliminaciones lógicas
        writeln('3: modificar novela'); //no se puede modificar el codigo de novela
        writeln('4: eliminar novela'); //eliminar lógicamente
        writeln('5: exportar novelas'); //incluir las eliminadas logicamente

        readln(opcion);

        case opcion of
            0:terminar := true;
            1:crearArchivo(a1);
            2: agregarNovela(a1);
            5: exportarNovelas(a1);
        end;
    end;

end.