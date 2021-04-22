using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealZone : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {

        Interactible pnj;
        if (other.TryGetComponent<Interactible>(out pnj))
        {
            if (pnj.blessed)
            {
                pnj.takable = false;
                pnj.blessed = false;
                pnj.GetComponent<Rigidbody>().isKinematic = true;
                pnj.transform.rotation = Quaternion.identity;
                Game.Instance.Help(pnj.transform);
            }


        }
    }
}
