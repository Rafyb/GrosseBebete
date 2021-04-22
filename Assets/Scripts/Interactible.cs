using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interactible : MonoBehaviour
{

    public string message = "";

    private void OnMouseEnter()
    {
        
    }

    private void OnMouseExit()
    {

    }

    void OnMouseDown()
    {
        Game.Instance.OpenText(message);
    }
}
