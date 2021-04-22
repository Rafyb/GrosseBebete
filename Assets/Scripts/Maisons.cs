using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Maisons : MonoBehaviour
{
    public List<Rigidbody> rbs;

    private void OnTriggerEnter(Collider other)
    {
        Controller player;
        if(other.TryGetComponent<Controller>(out player))
        {
            foreach(Rigidbody rb in rbs)
            {
                rb.isKinematic = false;
            }
            Destroy(gameObject);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
