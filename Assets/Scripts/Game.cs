using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    [HideInInspector] public static Game Instance;
    [HideInInspector] public int tree = 0;
    [HideInInspector] public int rock = 0;
    [HideInInspector] public int box = 0;
    [HideInInspector] public bool locked = false;

    private float goodBadTx; // Good 0 -> 100  |  Bad -100 -> 0

    [Header("Components")]
    public GameObject[] cornes;
    public GameObject[] ailes;
    public Transform cornesPos;
    public Transform ailesPos;
    public Material mat;
    public Animator anim;

    [Header("UI Top")]
    public Image jaugeGood;
    public Image jaugeBad;
    public TMPro.TextMeshProUGUI textTree;
    public TMPro.TextMeshProUGUI textRock;
    public TMPro.TextMeshProUGUI textBox;

    [Header("UI Tween")]
    public GameObject good;
    public GameObject bad;

    [Header("UI Dialogue")]
    public TMPro.TextMeshProUGUI text;
    public CanvasGroup dialogue;
    public GameObject buttonQuest;


    [Header("UI End")]
    public GameObject canvasEnd;
    public TMPro.TextMeshProUGUI textEnd;



    private void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        UpdateUI();
        buttonQuest.SetActive(false);
        canvasEnd.SetActive(false);
    }

    public void Help(Transform tf)
    {
        GameObject go = Instantiate(good,tf.position,tf.rotation);
        go.transform.parent = tf;
        go.transform.localScale = Vector3.zero;


        go.transform.DOMoveY(go.transform.position.y+2,1f).OnComplete(() => { go.transform.DOMoveY( go.transform.position.y + 2f, 1f); });
        go.transform.DOScale(1, 1f).OnComplete(() => { go.transform.DOScale(0, 1f); });

        goodBadTx += 20;
        UpdateUI();
    }

    public void BadAct(Transform tf)
    {
        GameObject go = Instantiate(bad, tf.position, tf.rotation);
        go.transform.localScale = Vector3.zero;
        go.transform.parent = tf;

        go.transform.DOMoveY(go.transform.position.y + 2, 1f).OnComplete(() => { go.transform.DOMoveY(go.transform.position.y + 2f, 1f); });
        go.transform.DOScale(1, 1f).OnComplete(() => { go.transform.DOScale(0, 1f); });

        Destroy(go, 2f);

        goodBadTx -= 10;
        UpdateUI();
    }



    /*
        ------------- UI 
    */

    public void OpenText(Interactible pnj)
    {
        dialogue.DOFade(1, 1f);
        text.text = pnj.message;
        locked = true;
        buttonQuest.SetActive(pnj.quest);
        buttonQuest.GetComponent<Button>().onClick.AddListener(pnj.DoQuest);

    }

    public void CloseText()
    {
        dialogue.DOFade(0, 1f);
        locked = false;
    }

    public void UpdateUI()
    {
        textBox.text = "X " + box;
        textTree.text = "X " + tree;
        textRock.text = "X " + rock;

        jaugeBad.fillAmount = 0;
        jaugeGood.fillAmount = 0;

        if (goodBadTx <= -100) End("Tu as choisi le coté Obscur");
        if (goodBadTx >= 100) End("Tu as choisi la voie de la sagesse");

        if (goodBadTx > 0)
        {
            jaugeGood.fillAmount = goodBadTx / 100;
            mat.SetColor("_EmissionColor", Color.gray);
            anim.SetBool("Dark", false);
        }
        else if (goodBadTx < 0)
        {
            jaugeBad.fillAmount = (-1*goodBadTx) / 100;
            mat.SetColor("_EmissionColor", Color.black);
            anim.SetBool("Dark", true);
        }
            
    }

    public void End(string txt)
    {
        locked = true;
        canvasEnd.SetActive(true);
        textEnd.text = txt;
    }

}
