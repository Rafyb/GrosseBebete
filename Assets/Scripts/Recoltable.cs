using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Recoltable : MonoBehaviour
{
    public bool recoltable = false;
    private Color color;
    public GameObject mesh;

    private void Start()
    {
        color = mesh.GetComponent<Renderer>().material.color;
    }

    private void OnTriggerEnter(Collider other)
    {
        Controller player;
        if (other.TryGetComponent<Controller>(out player))
        {
            player.Collectables.Add(gameObject);
            mesh.GetComponent<Renderer>().material.color = Color.green;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        Controller player;
        if (other.TryGetComponent<Controller>(out player))
        {
            player.Collectables.Remove(gameObject);
            mesh.GetComponent<Renderer>().material.color = color;
        }
    }
}
