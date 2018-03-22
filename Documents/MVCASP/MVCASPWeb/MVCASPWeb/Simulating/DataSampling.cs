using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class DataSampling
{
    public DateTime time;

    public Topo _topology;
    public DataConstraint _datConstraint;
    public Shape _shape2D;
    public Model model;
    public DataSampling()
    { 
    
    }

    public enum SamplingType: int{
        Random = 1,
        Default,
        UserDecide,
        Refer
    }


    public Boolean isSamplingValid()
    {
        return (isSamplingValidateTopo() && isSamplingValidateDataConstraint() && isSamplingValidateShape());
    }

    public Boolean isSamplingValidateTopo()
    {
        return true;
    }

    public Boolean isSamplingValidateDataConstraint()
    {
        return true;
    }

    public Boolean isSamplingValidateShape()
    {
        return true;
    }
}
