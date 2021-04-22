using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum TypeRessource
{
    Tree, Rock, Box
}
public class Recoltable : MonoBehaviour
{
    public bool recoltable = false;
    public TypeRessource type;
    private Color color;


    private void Start()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        Controller player;
        if (other.TryGetComponent<Controller>(out player))
        {
            player.Collectables.Add(gameObject);

        }
    }

    private void OnTriggerExit(Collider other)
    {
        Controller player;
        if (other.TryGetComponent<Controller>(out player))
        {
            player.Collectables.Remove(gameObject);

        }
    }
}
