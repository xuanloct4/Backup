using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

// A delegate type for hooking up change notifications.
public delegate void ConflictEventHandler(object sender, EventArgs e);
public class ConflictEvent
{

    // An event that clients can use to be notified whenever the
    // elements of the list change.
    public event ConflictEventHandler conflict;

    // Invoke the Changed event; called whenever list changes
    protected virtual void OnFlict(EventArgs e)
    {
        if (conflict != null)
            conflict(this, e);
    }

}

public class ConflictEventListener
{
    private ConflictEvent evt;

    public ConflictEventListener(ConflictEvent _evt)
    {
        evt = _evt;
        // Add "ListChanged" to the Changed event on "List".
        evt.conflict += new ConflictEventHandler(_handler);
    }

    // This will be called whenever the list changes.
    private void _handler(object sender, EventArgs e)
    {
        System.Diagnostics.Debug.WriteLine("This is called when the event fires.");
    }
}
public class Checker
{
    public Simulator _sim;
    public DataConstraint _datConstraint;
    //public DataSampling _sampling;
    //public CustomTuple tuple;
    public Checker()
    {

    }

    public void checkSimulatorWorking()
    {
        Simulator sim = new Simulator();
        sim.setDataSamplingSet();
        sim.simulatorDataFromSampling();
        sim.addConflictEvt();
        sim.start();
    }


    public void processWhenHaveConflictSig()
    {
        List<Model> _mods = new List<Model>();
        for (int i = 0; i < _mods.Count; i++/* Model model */)
        {
            //if (_mods.ElementAt(i).isUnFiledDataLink())
            //{
            //    _sim.simulateunFiledDataLinkInRange();
            //}
            //else
            //{
            //    letUserChooseOrDefine();
            //}
        }

    }

    public void letUserChooseOrDefine()
    {
        applyFromDefinition();

        handleAfterUserChoose();
    }

    public void applyFromDefinition()
     {
     
     }
    public void handleAfterUserChoose()
    {

    }

}