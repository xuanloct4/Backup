using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;

public class ShareInfo
{
    public AvailableShares shareOps;
    public Object infoForShare;
    public Obligation obligation;
    public ShareInfo()
    {

    }
}


public class ObjectCommunicator
{
    public ObjectCommunicator()
    {
    
    }
    public List<Communicator> communicators;
    public OrderOperate order;
    //public int numberCommunicators;

}
public class Communicator
{
    public List<Object> availableKindObj;
    public List<ShareInfo> sharing;
    public Communicator()
    {

    }
}
public enum OrderOperate
{
    Serial = 0,
    Parallel
}

public enum Obligation
{
    BeSuppress = 0,
    BeTuning,
    SuppressOn,
    TuningOn
}

public enum AvailableShares
{
    Available = 0,
    Hidden,
    AvalableForKind,
    AvalableForObject
}

public class Topo
{

    public Model components;

    public List<CustomTuple> elementSet;

    public List<Relation> relations;
    public Topo()
    {

    }

    public void createConfiguration()
    {

    }

    public static Boolean couldBeParallel()
    {
        return true;
    }

    public static Boolean couldbeSerial()
    {
        return true;
    }

    public Point getRelativePosition(Model _components)
    {
        return new Point(0, 0);
    }

    public Point getRelativePosition(Model _components, Model _coordComponents)
    {
        return new Point(0, 0);
    }

    public Shape getRelativeShape(Model _components)
    {
        return new Shape();
    }

    public Shape getRelativeShape(Model _components, Model _coordComponents)
    {
        return new Shape();
    }
}