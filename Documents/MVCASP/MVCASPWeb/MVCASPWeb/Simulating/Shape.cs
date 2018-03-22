using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using MVCASPWeb.Simulating;
public class Shape
{
    //public Tuple;
    public CustomTuple tuple;
    public Size size { get; set; }

    public Point Location { get; set; }

    public nDShape multiDimShape;

    public Shape2D shapeDim;

     public List<Standard> standards;
    public Shape()
    {
    }

    public Shape shapeByTransform(Matrix _matrix)
    {
        return new Shape();
    }

    public Shape shapeFrom2D(Shape _2Dshape)
    {

        return _2Dshape;
    }

    public Shape shapeFromnD(Shape _nDshape)
    {
        return _nDshape;
    }
}

public class Shape2D
{
    public Shape2D()
    {

    }

}

public class nDShape
{
    public nDShape()
    {

    }

}

public class Matrix
{
    public int row;
    public int column;

    private CustomTuple listRows;

    private CustomTuple listColumns;

    public CustomTuple values;
    public Matrix()
    {

    }

    public Matrix(CustomTuple _listRow)
    {
        listRows = _listRow;
    }

    //public Matrix(CustomTuple _listColumns)
    //{
    //    listColumns = _listColumns;
    //}

    public CustomTuple getRow(int _row)
    {
        return (CustomTuple)listRows.getElement(_row);
    }

    public CustomTuple getColumn(int _column)
    {
        List<Object> columnElements = new List<Object>();
        for (int i = 0; i < row; i++)
        {
            columnElements.Add(this.getElement(i, _column));
        }
        return new CustomTuple(columnElements);
    }

    public Object getElement(int _row, int _column)
    {
        return this.getRow(_row).getElement(_column);
    }

    public Boolean setElement(Object _element, int _row, int _column)
    {
       return this.getRow(_row).setElement(_element,_column);
    }




    public static Boolean isMatrixWellFormed(Matrix _matrix)
    {

        //Check if number of row and col is greater than 0
        if ((_matrix.row <= 0) || (_matrix.column <= 0))
        {
            return false;
        }

        //Check if total number of elements is equal to row x col
        if (_matrix.values == null)
        {
            return false;
        }
        else
        {
            if (_matrix.values.getSize() != (int)(_matrix.row * _matrix.column))
            {

                return false;
            }
        }

        return true;
    }

}

public interface IComparable
{
     Boolean isEqualTo(IComparable obj);
}
public class CustomTuple: IComparable
{
    public List<Object> elementList;

    public Boolean isEqualTo(IComparable obj)
    {
      if ((CustomTuple)obj == null)
        {
            return false;
        }
        else { 
            if(this.getSize() != ((CustomTuple)obj).getSize())
            {
                return false;
            }
            for (int i = 0; i < this.getSize(); i++)
            { 
                IComparable compo1 = (IComparable)this.getElement(i);
                 IComparable compo2 = (IComparable)((CustomTuple)obj).getElement(i);
                 if (!compo1.isEqualTo(compo2))
                 {
                     return false;
                 }
            }
            return true;
        }
    }


    public CustomTuple()
    {
        elementList = new List<Object>();
    }



    public CustomTuple(List<Object> _elementList)
    {
        this.elementList = _elementList;
    }
    public Object getElement(int _index)
    {
        return elementList.ElementAt(_index);
    }

    public Boolean setElement(Object _object, int _index)
    {
        if ((_index > this.getSize() - 1) || (_index < 0))
        {
            return false;
        }
        else {
            elementList[_index] = _object;
            return true;
        }
    }

    public void add(Object _object)
    {
        elementList.Add(_object);
    }

    public void remove(int _index)
    {
        elementList.Remove(_index);
    }
    public int getSize()
    {
        if (elementList == null)
        {
            return 0;
        }
        return elementList.Count;
    }

    //public List<T> elements;
    //public CustomTuple<T> createTuple(params T[] element)
    //{
    //   CustomTuple<T> _tuple = new CustomTuple<T>();

    //   return _tuple;
    //}


    ////Example
    //class TestParams
    //{
    //    private static void Average(string title, params int[] values)
    //    {
    //        int sum = 0;
    //        System.Console.Write("Average of {0} (", title);

    //        for (int i = 0; i < values.Length; i++)
    //        {
    //            sum += values[i];
    //            System.Console.Write(values[i] + ", ");
    //        }
    //        System.Console.WriteLine("): {0}", (float)sum / values.Length);
    //    }
    //    static void Main()
    //    {
    //        Average("List One", 5, 10, 15);
    //        Average("List Two", 5, 10, 15, 20, 25, 30);
    //    }
    //}

}

