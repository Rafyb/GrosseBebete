using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Interactible : MonoBehaviour
{

    public string message = "";

    public bool takable = false;


    void OnMouseDown()
    {
        Game.Instance.OpenText(message);
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
}
