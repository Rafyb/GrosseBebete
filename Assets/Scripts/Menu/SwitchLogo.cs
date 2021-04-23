using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SwitchLogo : MonoBehaviour
{
    public RawImage logo;

    public Texture Logo1;
    public Texture Logo2;

    private bool switchLogo = true;

    private float timePassed = 0f;


    // Update is called once per frame
    void Update()
    {
        timePassed += Time.deltaTime;

        if( timePassed > 3f)
        {
            timePassed -= 3f;

            if (switchLogo)
            {
                logo.DOFade(0f, 0.5f).OnComplete(() =>
                {
                    logo.texture = Logo2;
                    logo.DOFade(1f, 0.5f);
                }); ;
                

            }
            else
            {
                logo.DOFade(0f, 0.5f).OnComplete(() =>
                {
                    logo.texture = Logo1;
                    logo.DOFade(1f, 0.5f);
                }); ;
            }

            switchLogo = !switchLogo;
        }
    }
}
