program dk;

type point = record // запись точки
  x, y : real;
end;

type vector = record // запись вектора
  start, tip : point;
  lenght : real;
end;

type vectorsCollection = array [0..5] of vector; // массив векторов
type pointsCollection = array [0..3] of point; // массив точек

const numberOfPoints = 4; // константа количества точек
const numberOfVectors = 6; // константа количества векторов
const t = 0.00000001; // константа для точности сравнения

var // инициализирование переменных
  vectors : vectorsCollection;
  points : pointsCollection;

function numberEnding(number : integer): string; { функция для выбора окончания
                                                   порядкового номера числа    }
begin
  case number of
    1 : result := 'st';
    2 : result := 'nd';
    3 : result := 'rd';
    else result := 'th';
  end;
end;

function calcVectorsIntersection(const vecFir : vector; const vecSec : vector): point;
var
  divide : real;
begin
  divide := (vecFir.start.x - vecFir.tip.x) * (vecSec.start.y - vecSec.tip.y)
          - (vecFir.start.y - vecFir.tip.y) * (vecSec.start.x - vecSec.tip.x);
  if (divide <> 0) 
  then begin
         result.x := ((vecFir.start.x * vecFir.tip.y - vecFir.start.y * vecFir.tip.x)
                   * (vecSec.start.x - vecSec.tip.x) 
                   - (vecSec.start.x * vecSec.tip.y - vecSec.start.y * vecSec.tip.x)
                   * (vecFir.start.x - vecFir.tip.x)) / divide;
         result.y := ((vecFir.start.x * vecFir.tip.y - vecFir.start.y * vecFir.tip.x)
                   * (vecSec.start.y - vecSec.tip.y)
                   - (vecSec.start.x * vecSec.tip.y - vecSec.start.y * vecSec.tip.x)
                   * (vecFir.start.y - vecFir.tip.y)) / divide;
       end
   else begin
          result.x := vecFir.start.x;
          result.y := vecFir.start.y;
        end;
end;

{ функция для подсчёта длины вектора }
function calcVectorLenght(const first : point; const second : point): real;
begin
  result := abs(sqrt(sqr(first.x - second.x) + sqr(first.y - second.y))); // формула длины вектора по координатам
end;

{ функция для считывания точек }
procedure readPoints(var points : pointsCollection); 
var
  number : integer;
begin
  number := 0;  
  repeat 
    inc(number);
    write('Enter the ', number, numberEnding(number), ' point: ');
    read(points[number-1].x);
    read(points[number-1].y);
  until (number = numberOfPoints); 
end;

{ функция создания вектора из точек }
function createVector(const start : point; const tip : point): vector; 
var
  i, j : integer;
begin
  result.start.x := start.x;
  result.start.y := start.y;
  result.tip.x := tip.x;
  result.tip.y := tip.y;
  result.lenght := calcVectorLenght(result.start, result.tip);
end;

{ функция проверки параллелограмма }
function isParallelogram(const vectors : vectorsCollection): boolean;
var 
  i, j : integer;
  divide : real;
  diagFirSt, diagFirTip, diagSecSt, diagSecTip: vector;
  vecInter : point;
begin
  for i := 0 to numberOfVectors - 2 do
    for j := i + 1 to numberOfVectors - 1 do
    begin
      vecInter := calcVectorsIntersection(vectors[i], vectors[j]);
      diagFirSt := createVector(vectors[i].start, vecInter);
      diagFirTip := createVector(vectors[i].tip, vecInter);
      diagSecSt := createVector(vectors[j].start, vecInter);
      diagSecTip := createVector(vectors[j].tip, vecInter);
      if ((diagFirSt.lenght = diagFirTip.lenght) 
      and (diagSecSt.lenght = diagSecTip.lenght))
      and (diagFirSt.lenght * diagFirTip.lenght * diagSecSt.lenght
         * diagSecTip.lenght <> 0)
      then begin
             result := true;
             exit;
           end;
    end;
  result := false;
end;

{ процедура задания векторов }
procedure setVectors(var vectors : vectorsCollection);
var 
  i, j, vectorIndex : integer;
begin
  vectorIndex := 0;
  for i := 0 to numberOfPoints - 2 do
    for j := i + 1 to numberOfPoints - 1 do
    begin
      vectors[vectorIndex] := createVector(points[i], points[j]);
      inc(vectorIndex);
    end;
end;

begin
  writeln('Enter 4 points of type: x y'); // инструкция для пользователя
  readPoints(points); // считывание точек
  
  setVectors(vectors); // создание векторов
  if (isParallelogram(vectors))
  then write('The points are the angles of the parallelogram')
  else write('The points are not the angles of the parallelogram');
end.
  