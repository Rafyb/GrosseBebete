using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicManager : MonoBehaviour
{


    public AudioSource audioSource;
    public bool enclenched = false;

    // Start is called before the first frame update
    void Start()
    {
        audioSource.Play();
        audioSource.volume = 0;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Enclenche()
    {
        if (enclenched) return;

        enclenched = true;
        StartCoroutine(Up());
    }

    IEnumerator Up()
    {
        audioSource.volume += 0.1f;
        yield return new WaitForSeconds(1.0f);

        if (enclenched && audioSource.volume < 1f) StartCoroutine(Up());
    }

    public void Desenclenche()
    {
        if (!enclenched) return;

        enclenched = false;
        StartCoroutine(Down());
    }

    IEnumerator Down()
    {
        audioSource.volume -= 0.1f;
        yield return new WaitForSeconds(1.0f);

        if (!enclenched && audioSource.volume > 0f) StartCoroutine(Down());
    }
}
