using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

    public class ObjectStructure
    {
    public Model _model;
    public ContactingFacet _facet;
    public InternalElement _internal;
    public ObjectStructure()
    {

    }
    public ObjectStructure(Model model)
    {
        _facet = new ContactingFacet(model);
        _internal = new InternalElement(model);
    }


}