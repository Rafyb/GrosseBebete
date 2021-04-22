using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tree : Recoltable
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if( (transform.rotation.z + 90) < 1f || (transform.rotation.z - 90) < 1f)
        {
            recoltable = true;
        }
    }
}
