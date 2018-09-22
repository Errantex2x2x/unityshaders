using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Damager : MonoBehaviour {

    [SerializeField]
    string damageShaderParamName = "";

    [SerializeField]
    AnimationCurve curve;

    [SerializeField]
    float damageAmount = 0;


    Renderer objRenderer;
    Material objMat;

	// Use this for initialization
	void Awake () {
        objRenderer = GetComponent<Renderer>();
        objMat = objRenderer.material;
    }
	
	// Update is called once per frame
	void Update ()
    {
        damageAmount = Mathf.MoveTowards(damageAmount, 1, Time.deltaTime);

        objMat.SetFloat(damageShaderParamName, curve.Evaluate(damageAmount));

        if (Input.GetMouseButtonDown(0) && damageAmount >= .91)
            damageAmount = 0;
	}
}
