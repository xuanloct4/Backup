using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class ProcessReflector
{
    public Checker checker;
    public Model model;

    public ProcessReflector()
    {

    }

    public void checkToReflectModel(Model _model, Checker _checker)
    {
        Boolean isOK = decideWhichPartShouldReflected(_checker);
        simulateFromThePart();
        if (!isOK)
        {
            checkToReflectModel(_model, _checker);
        }
        else
        {
            saveToSample();
            // 
            adjustModel(_model);
        }
    }

    public void saveToSample()
    {

    }

    public void adjustModel(Model _model)
    {

    }
    public void simulateFromThePart()
    {

    }

    public Boolean decideWhichPartShouldReflected(Checker _checker)
    {
        return true;
    }

    public void statisticSimulation(Model _model, Checker _checker)
    {

    }
}