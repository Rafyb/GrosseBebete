using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    private Transform tf;              // this transform
    private Vector3 dest;        // The destination Point
    private float dist;

    public float speed = 100f;

    public Cinemachine.CinemachineVirtualCamera cam;

    public GameObject targetedPrefab;
    private GameObject targeted;

    void Start()
    {
        tf = GetComponent<Transform>();
        dest = tf.position;
    }

    void Update()
    {

        if (Input.GetMouseButtonDown(0))
        {
            Plane playerPlane = new Plane(Vector3.up, tf.position);
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            float hitdist = 0.0f;

            if (playerPlane.Raycast(ray, out hitdist))
            {
                if(targeted != null)
                {
                    Destroy(targeted);
                }

                //Deplacement
                dest = ray.GetPoint(hitdist);
                dest.y = tf.position.y;

                targeted = Instantiate(targetedPrefab, dest, Quaternion.identity);


                dist = Vector3.Distance(tf.position, dest);

                tf.DOKill();
                tf.DOMove(dest, dist * (1/speed) ).OnComplete( ()=> {
                    if (targeted != null)
                    {
                        Destroy(targeted);
                    }
                });

                // Rotation
                Vector3 targetPoint = ray.GetPoint(hitdist);
                Quaternion targetRotation = Quaternion.LookRotation(targetPoint - transform.position);
                tf.rotation = targetRotation;
            }
        }

        if (Input.GetAxis("Mouse ScrollWheel") > 0f) // forward
        {
            if (cam.m_Lens.OrthographicSize < 20) cam.m_Lens.OrthographicSize++;
        }
        else if (Input.GetAxis("Mouse ScrollWheel") < 0f) // backwards
        {
            if(cam.m_Lens.OrthographicSize > 5 ) cam.m_Lens.OrthographicSize--;
        }





    }
    
}
