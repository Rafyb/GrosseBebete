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
                //Deplacement
                dest = ray.GetPoint(hitdist);
                dest.y = tf.position.y;
                dist = Vector3.Distance(tf.position, dest);
                tf.DOMove(dest, dist * (1/speed) );

                // Rotation
                Vector3 targetPoint = ray.GetPoint(hitdist);
                Quaternion targetRotation = Quaternion.LookRotation(targetPoint - transform.position);
                tf.rotation = targetRotation;
            }
        }






    }
    
}
