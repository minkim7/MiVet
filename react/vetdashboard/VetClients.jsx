import React, { useState } from "react";
import { useEffect } from "react";
import {Card, Row, Col, Button, Table,  } from 'react-bootstrap';
import sabioDebug from "sabio-debug";
import ProfileLayout from "./ProfileLayout";
import VetDashboardTable from "./VetDashboardTable";
import {getByVetIdByMonth} from "services/appointmentService"
import VetClientsCard from "./VetClientsCard";


function VetClients(props) {
    const _logger = sabioDebug.extend("VetDashboard-clients");
    const [vetClients , setVetClients] = useState({
		list: [],
        component: [],
    });
    const [listType, setListType] = useState();
    _logger(props);
    _logger(vetClients);
    useEffect(() => {
        
		getByVetIdByMonth(7 , 6)
			.then(vetProfileSuccess)
			.catch(vetProfileError)
		
	
	}, []);
    const mapper = anAppointment => {
        
        return (
            <VetDashboardTable type="client" data={anAppointment} />
        )
    }
    const mapperV2 = anAppointment => {
        return (
            <Col lg={3} mg={3} className="m-3">
                <VetClientsCard data={anAppointment}></VetClientsCard>
            </Col>

            
        )
    }
   
	const vetProfileSuccess = resp => {
		_logger("vetProfileSuccess", resp);
		setVetClients(prevState => {
			 const pd = { ...prevState };
            pd.list = resp.item.pagedItems;
            pd.component = resp.item.pagedItems.map(mapper);
            //testing
            pd.component2 = resp.item.pagedItems.map(mapperV2);
            return pd;
		})
		
	};
	const vetProfileError = err => {
		_logger("vetProfileError", err);

    };
    const typeChange = e => {
        setListType(e.target.value);
    }

    return (
        <ProfileLayout >
            
                

            
            <Card className="border-0 mt-4">
                <Card.Header>
                    <h3 className="mb-0 h4">Clients</h3>
                </Card.Header>
                <Card.Body>
                    <Row className="align-items-center">
                        <Col lg={3} md={6} className="pe-md-0 mb-2 mb-lg-0">
                            <select name className="form-select" defaultValue={0}>
                                <option value={0} className="text-muted">Select Option</option>
                                <option value={30} className={"text-dark"}>Due</option>
                                <option value={60} className={"text-dark"}>Last 10 Invoices</option>
                                <option value={180} className={"text-dark"}>Paid 10 Invoices</option>
                            </select>
                        </Col>
                        <Col lg={4} md={6} className="mb-2 mb-2 mb-lg-0">
                            <select name className="form-select" value={listType} onChange={typeChange}>
                                <option value={''} className="text-muted">Select View Option</option>
                                <option value={'card'} className={"text-dark"}>Card</option>
                                <option value={'table'} className={"text-dark"}>Table</option>
                                
                            </select>
                        </Col>
                        <Col lg={2} md={6} className="text-lg-end">
                            <Button
                                variant="link"
                                href="#"
                                download=""
                                className="btn-outline-white"
                            >
                                <i className="fe fe-download"></i>
                            </Button>
                        </Col>
                    </Row>
                    {listType === 'card' &&
                        (<Row className="align-items-center">
                            {vetClients.component2}

                        </Row>)}
                </Card.Body>
                {listType === 'table' &&
                    (<Card>
                        <div className="table-responsive ">
                            <Table className="text-nowrap">
                                <thead className="table-light " >
                                    <tr className="text-center">
                                        <th scope="col">Email</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Notes</th>
                                        <th scope="col">Location</th>
                                        <th scope="col">Date</th>
                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    {vetClients.component}
                                
                                </tbody>
                            </Table>

                        </div>
                    </Card>)}
            </Card>
        </ProfileLayout>
    )
}

export default VetClients;