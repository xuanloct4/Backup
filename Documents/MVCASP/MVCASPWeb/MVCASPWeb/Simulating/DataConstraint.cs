using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MVCASPWeb.Simulating;
public class DataConstraint
{
    public Model _model;
    public Topo topo;

    public CustomTuple insideInfo;

    public Standard constraintStandards;
    public DataConstraint()
    {

    }

    public Boolean isValidDataConstraint(DataConstraint constraints)
    {
        CustomTuple stDataSet = constraints.constraintStandards.standards;
        if (!constraintStandards.isPassStandard(stDataSet))
        {
            return false;
        }
        else
        {
            return true;
        }
    }


}


public interface IRelation
{
    CustomTuple verificationResult(CustomTuple _actions, CustomTuple _tuple);

}
public class Relation : IRelation
{
    public CustomTuple tuple;
    public CustomTuple actions;

    public Standard standards;


    public Relation()
    {

    }

    public Relation(CustomTuple _tuple, CustomTuple _actions, Standard _standards)
    {
        tuple = _tuple;
        actions = _actions;
        standards = _standards;
    }
    public Boolean isValidRelation(CustomTuple _tuple, CustomTuple _actions, Standard _standards)
    {
        CustomTuple _result = verificationResult(_actions, _tuple);
        if (standards.isPassStandard(_result))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public CustomTuple verificationResult(CustomTuple _actions, CustomTuple _tuple)
    {
        CustomTuple _result = new CustomTuple();
        for (int i = 0; i < _actions.getSize(); i++)
        {
            CustomAction _action = (CustomAction)_actions.getElement(i);
            _result.add(verificationResult(_action, _tuple));
        }
        return _result;
    }

    public CustomTuple verificationResult(CustomAction _action, CustomTuple _tuple)
    {
        CustomTuple _result = new CustomTuple();

        return _result;
    }
}

public class CorrelateRelation : OrderRelation
{
    public CorrelateRelation()
    {

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

public interface IAction
{
     CustomTuple resultFromAction(CustomTuple _target);
     IAction inverseAction(IAction action);
}
public class CustomAction:IAction
{
    public CustomTuple target;
    public CustomTuple result;
    public CustomAction()
    {

    }

    public IAction inverseAction(IAction action)
    {
        return new CustomAction();
    }

    public CustomTuple resultFromAction(CustomTuple _target)
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