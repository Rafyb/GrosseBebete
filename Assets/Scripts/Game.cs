using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Game : MonoBehaviour
{
    [HideInInspector] public static Game Instance;

    private float goodBadTx; // Good 0 -> 100  |  Bad -100 -> 0

    public GameObject good;
    public GameObject bad;

    private void Awake()
    {
        Instance = this;
    }

    public void Help(Transform tf)
    {
        GameObject go = Instantiate(good,tf.position,tf.rotation);
        go.transform.localScale = Vector3.zero;

        go.transform.DOMoveY(go.transform.position.y+2,1f).OnComplete(() => { go.transform.DOMoveY( go.transform.position.y + 2f, 1f); });
        go.transform.DOScale(1, 1f).OnComplete(() => { go.transform.DOScale(0, 1f); }); 
    }

}
