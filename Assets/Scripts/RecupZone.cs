using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RecupZone : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        Interactible villager;
        Recoltable items;
        if (other.TryGetComponent<Interactible>(out villager))
        {

            Destroy(gameObject);
        }
        if (other.TryGetComponent<Recoltable>(out items))
        {
            
            Destroy(gameObject);
        }
    }
}
