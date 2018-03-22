using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class DataConstraint
{
    public Model _model;
    public Topo topo;
    public List<Object> insideInfo;
    public DataConstraint()
    {

    }
}

public class Relation
{
    public CustomTuple tuple;
    public CustomTuple actions;
    public CustomTuple verificatioResult(CustomTuple _actions, CustomTuple _tuple)
    {
        CustomTuple _result = new CustomTuple();
        for (int i = 0; i < _actions.getSize(); i++)
        {
            CustomAction _action = (CustomAction)_actions.getElement(i);
            _result.add(verificatioResult(_action, _tuple));
        }
        return _result;
    }

    public CustomTuple verificatioResult(CustomAction _action, CustomTuple _tuple)
    {
        CustomTuple _result = new CustomTuple();
        
        return _result;
    }
}

public class OrderRelation : Relation
{
    public OrderRelation()
    {

    }
}

public class ScalarRelation : Relation
{
    public ScalarRelation()
    {

    }
}
public class CustomAction
{
    public CustomTuple target;
    public CustomTuple result;
    public CustomAction()
    {

    }

    public CustomTuple resultFromAction()
    {
        CustomTuple _result = new CustomTuple();
        return _result;
    }
}

public class CustomOperator : CustomAction
{
    public CustomOperator()
    {

    }
}