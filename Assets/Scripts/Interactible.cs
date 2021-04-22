using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Interactible : MonoBehaviour
{

    public string message = "";

    public bool takable = false;
    public bool blessed = false;
    public bool interact = true;

    void OnMouseDown()
    {
        if(interact)Game.Instance.OpenText(message);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!takable) return;

        Controller player;
        if (other.TryGetComponent<Controller>(out player))
        {
            player.Collectables.Add(gameObject);

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (!takable) return;

        Controller player;
        if (other.TryGetComponent<Controller>(out player))
        {
            player.Collectables.Remove(gameObject);

        }
    }

    void Update()
    {
        if (transform.rotation.z > 1f || transform.rotation.z < 0f)
        {
            if (takable && !blessed)
            {
                Game.Instance.BadAct(transform);
                blessed = true;
            }
        }
    }
}
