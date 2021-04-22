using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Interactible : MonoBehaviour
{

    public string message = "";

    public bool takable = false;
    public bool blessed = false;
    public bool interact = true;
    [Header("Quest")]
    public bool quest = false;
    public int nb;
    public TypeRessource type;

    void OnMouseDown()
    {
        if(interact)Game.Instance.OpenText(this);
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

    public void DoQuest()
    {
        if (!quest) return;
        if(type == TypeRessource.Tree && Game.Instance.tree >= nb)
        {
            Game.Instance.tree -= nb;
            Game.Instance.CloseText();
            Game.Instance.Help(transform);
        }
        if (type == TypeRessource.Box && Game.Instance.box >= nb)
        {
            Game.Instance.box -= nb;
            Game.Instance.CloseText();
            Game.Instance.Help(transform);
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
