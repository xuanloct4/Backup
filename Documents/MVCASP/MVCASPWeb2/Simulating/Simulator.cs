using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class Simulator
{
    public ObjectStructure _objStruct;
    public DataSampling _sampling;

    public Simulator()
    {

    }

    public void setDataSamplingSet()
    {
        //while ()
        //{
        //    _sampling.time =;
        //    _sampling.model = ;
        //    _sampling.isSamplingValid();
        // }

    }

    public void start()
    {

    }

    public void addConflictEvt()
    {
        ConflictEvent evt = new ConflictEvent ();
               evt.conflict += new ConflictEventHandler(_handler);
    }

    // This will be called whenever conflict.
    private void _handler(object sender, EventArgs e)
    {
        System.Diagnostics.Debug.WriteLine("This is called when the event fires.");
    }

    public Model simulatorDataFromSampling()
    {
        List<Model> _mods = new List<Model>();
        for (int i = 0; i < _mods.Count; i++/* Model model */)
        {
            startFromInitializer();

            if (Topo.couldBeParallel())
            {
                filingData();
            }
            else if (Topo.couldbeSerial())
            {
                waitTillNewDataFiledTo();
            }
        }
        return new Model();
    }

    public void startFromInitializer()
    {
        //

    }



    public void simulateunFiledDataLinkInRange()
    {
        //

    }

    public void filingData()
    {
        //...
        extractUnFiledDataLink();
        //....

    }

    public void waitTillNewDataFiledTo()
    {

    }

    public void extractUnFiledDataLink()
    {

    }
}