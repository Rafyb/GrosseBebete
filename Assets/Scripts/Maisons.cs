using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Maisons : MonoBehaviour
{
    public List<Rigidbody> rbs;
    public GameObject fx;

    private void OnTriggerEnter(Collider other)
    {
        Controller player;
        if(other.TryGetComponent<Controller>(out player))
        {
            foreach(Rigidbody rb in rbs)
            {
                rb.isKinematic = false;
            }
            Instantiate(fx, transform.position, Quaternion.identity);
            Game.Instance.BadAct(gameObject.transform);
            Destroy(gameObject);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
